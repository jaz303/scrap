with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Jewl.Simple_Windows; use  Jewl.Simple_Windows;

procedure Game_Of_Life is
   
   -- Constants and stuff
   Cols : constant Integer := 500;          -- Number of columns
   Rows : constant Integer := 500;          -- Number of rows
   
   Origin : constant Point_Type := (10,40); -- Where the drawing on the frame starts from
   
   Visible_Cols : constant Integer := 60;   -- Number of columns to show
   Visible_Rows : constant Integer := 60;   -- Number of rows to show
   
   Cell_Side : constant Integer := 9;       -- Size of a cell
   
   -- Dimensions and spacing for various widgets
   Scroll_Button_Width  : constant Integer := 20;
   Scroll_Button_Height : constant Integer := 20;
   Control_Button_Width : constant Integer := 80;
   Control_Button_Height: constant Integer := 30;
   Control_Button_Space : constant Integer := 10;
   
   -- Make the canvas large enough to display all the cells
   Canvas_Width  : constant Integer := (Visible_Cols * Cell_Side) + 3;
   Canvas_Height : constant Integer := (Visible_Rows * Cell_Side) + 2;
   
   -- Make the frame large enough to hold the canvas and the buttons
   F_Width  : constant Integer := (2 * Origin.X) + Canvas_Width + Scroll_Button_Width + 8;
   F_Height : constant Integer := Origin.Y + Canvas_Height + Scroll_Button_Height + 80;
   
   -------------------------------------------------------------
   -- JEWL owns you hardcore -----------------------------------
   -------------------------------------------------------------
   F1 	 : Frame_Type          := Frame (F_Width, F_Height,"Game of Life", 'X');   
   C_Pos : constant Point_Type := (10, 40); -- position of canvas 
   C     : Canvas_Type         := Canvas (F1, Origin, Canvas_Width, Canvas_Height, 'X');
   
   Btn_Scroll_Left   : Button_Type := Button (F1, (Origin.X,Origin.Y+Canvas_Height), Scroll_Button_Width, Scroll_Button_Height, "<", 'L');
   Btn_Scroll_Right  : Button_Type := Button (F1, (Origin.X+Canvas_Width-Scroll_Button_Width,Origin.Y+Canvas_Height), Scroll_Button_Width, Scroll_Button_Height, ">", 'R');
   Btn_Scroll_Up     : Button_Type := Button (F1, (Origin.X+Canvas_Width,Origin.Y), Scroll_Button_Width, Scroll_Button_Height, "/\", 'U');
   Btn_Scroll_Down   : Button_Type := Button (F1, (Origin.X+Canvas_Width,Origin.Y+Canvas_Height-Scroll_Button_Height), Scroll_Button_Width, Scroll_Button_Height, "\/", 'D');
   
   Btn_Quit          : Button_Type := Button (F1, (Origin.X,Origin.Y+Canvas_Height+Scroll_Button_Height+10), Control_Button_Width, Control_Button_Height, "Quit", 'Q');
   Btn_Toggle        : Button_Type := Button (F1, (Origin.X+Control_Button_Width+Control_Button_Space,Origin.Y+Canvas_Height+Scroll_Button_Height+10), Control_Button_Width, Control_Button_Height, "Start", 'T');
   Btn_Clear         : Button_Type := Button (F1, (Origin.X+(2*(Control_Button_Width+Control_Button_Space)),Origin.Y+Canvas_Height+Scroll_Button_Height+10), Control_Button_Width, Control_Button_Height, "Clear", 'C');
   Btn_About         : Button_Type := Button (F1, (Origin.X+(3*(Control_Button_Width+Control_Button_Space)),Origin.Y+Canvas_Height+Scroll_Button_Height+10), Control_Button_Width, Control_Button_Height, "About", 'A');
   
   Lbl_Gen_Count     : Label_Type  := Label  (F1, (Origin.X+Canvas_Width-160,13),0,20,"Generation count: 0");
   Lbl_Camera        : Label_Type  := Label  (F1, (Origin.X,13),150,20,"Camera:");

   -------------------------------------------------------------
   ------------------------------------------------------------- 
   
   Frame_Delay : constant Duration := 0.3;      -- Delay between each iteration of the game
   
   -- Subtypes for row and column numbers
   -- The actual range is from 1 less to 1 above the number of rows/cols
   -- This allows us to calculate the number of neighbours without using
   -- any bounds checking (thus reducing 32 lines of code to 1 line of code!)
   subtype Col_Type is Integer range 0..Cols + 1;
   subtype Row_Type is Integer range 0..Rows + 1;
   
   -- 2 dimensional array representing the board
   -- TRUE: Cell is alive
   -- FALSE: Cell is dead
   type Game_Board_Type is array(Col_Type,Row_Type) of Boolean;
   
   -- We need to store 2 game boards in order to calculate
   -- the next game iteration from the current state. Indexing
   -- the array by boolean makes it easy to flip between the two.
   type Game_Board_Array_Type is array (Boolean) of Game_Board_Type;
   
   procedure Clear_Boards(G : in out Game_Board_Array_Type) is
   -- Clears the game boards in G by setting all values to FALSE
   -- There is probably a neat aggregate for this but I couldn't work it out!
   begin
      for Z in Boolean loop
         for X in Col_Type loop
            for Y in Row_Type loop
               G(Z)(X,Y) := False;
            end loop;
         end loop;
      end loop;
   end Clear_Boards;
   
   procedure Draw_Grid(C : in Canvas_Type) is
   -- Draws a grid on canvas C
   -- References the following global constants
      -- Visible_Rows  : constant Integer
      -- Visible_Cols  : constant Integer
      -- Cell_Side     : constant Integer
      -- Canvas_Width  : constant Integer
      -- Canvas_Height : constant Integer
   begin
      Set_Pen(C,Gray,1);
      for I in 1..Visible_Rows-1 loop
         Draw_Line(C,(0,Cell_Side * I),(Canvas_Width,Cell_Side * I));
      end loop;
      for I in 1..Visible_Cols-1 loop
         Draw_Line(C,(Cell_Side * I,0),(Cell_Side * I,Canvas_Height));
      end loop;
   end Draw_Grid;
   
   procedure Update_Gen_Count(G : in Integer) is
   -- Updates the label Lbl_Gen_Count to display number of generations G
   begin
      Set_Text(Lbl_Gen_Count,"Generation count: " & Integer'Image(G));
   end Update_Gen_Count;
   
   procedure Update_Camera(P : in Point_Type) is
   -- Updates the label Lbl_Camera to display the position of camera P
   begin
      Set_Text(Lbl_Camera,"Camera: " & Integer'Image(P.X) & "," & Integer'Image(P.Y));
   end Update_Camera;

   procedure Do_Game(G : in out Game_Board_Array_Type; S : in Boolean) is
   -- Calculates the next game iteration from the data stored in G(S),
   -- storing this data in G(not S)
      
      Nc : Integer;  -- Neighbour count for whichever cell is being processed
   
   begin
      
      -- Process each and every cell
      for X in 1..Cols loop
         for Y in 1..Rows loop
            
            -- Add up all of the surrounding cells
            Nc := Boolean'Pos(G(S)(X-1,Y)) + Boolean'Pos(G(S)(X+1,Y)) + Boolean'Pos(G(S)(X,Y-1)) + Boolean'Pos(G(S)(X,Y+1))
               + Boolean'Pos(G(S)(X-1,Y-1)) + Boolean'Pos(G(S)(X-1,Y+1)) + Boolean'Pos(G(S)(X+1,Y-1)) + Boolean'Pos(G(S)(X+1,Y+1));
            
            -- Implement game logic
            
            -- This cell is dead, and has 3 living neighbours,
            -- so it becomes a living cell.
            if (not G(S)(X,Y)) and Nc = 3 then
               G(not S)(X,Y) := True;
            
            -- This cell is alive and has 2 or 3 living neighbours,
            -- so it stays alive.   
            elsif (G(S)(X,Y)) and (Nc = 2 or Nc = 3) then
               G(not S)(X,Y) := True;
            
            -- In all other cases, the cell is dead.
            else
               G(not S)(X,Y) := False;
            end if;
            
          end loop;
      end loop;
      
   end Do_Game;
   
   procedure Draw_Cell(C : in Canvas_Type; X : in Natural; Y : in Natural; State : in Boolean) is
   -- Draws an individual cell on canvas C at grid reference X,Y. When State is TRUE, the cell
   -- will be black, when FALSE it will be white
   -- Note that the grid ref passed should be absolute grid co-ordinates and not board co-ordinates
   begin
      Set_Pen(C,White,0);
      if State then
         Set_Fill(C,Black);
      else
         Set_Fill(C,White);
      end if;
      Draw_Rectangle(C, ( ((X-1)*Cell_Side)+1, ((Y-1)*Cell_Side)+1 ) , ( ((X)*Cell_Side)+1, ((Y)*Cell_Side)+1 ) );
   end Draw_Cell;
   
   procedure Draw_Board(Can : in Canvas_Type; Cam : in Point_Type; G : in Game_Board_Type) is
   -- Draws the entire board G onto canvas Can, taking into account position of the camera Cam
   begin
      -- Restore the blank grid
      Restore(Can);
     
      -- Loop through every visible cell
      for X in 1..Visible_Cols loop
         for Y in 1..Visible_Rows loop
            
            -- Plot all living cells
            if G((X+Cam.X-1),(Y+Cam.Y-1)) then
               Draw_Cell(Can,X,Y,True);
            end if;
            
         end loop;
      end loop;
   end Draw_Board;
   
   -- Declarations
   Gbs             : Game_Board_Array_Type;         -- The array of game boards
   Current         : Boolean := False;              -- Current game board
   Gen_Count       : Integer := 0;                  -- Generation count
   Camera          : Point_Type := (Rows/2,Cols/2); -- Camera position - initialise to centre
   Game_Running    : Boolean := False;              -- Set to TRUE when game is running
   Exit_Game       : Boolean := False;              -- Set to TRUE when user quits game
   Click           : Point_Type;                    -- Registered position of mouse click
   Mod_Click       : Point_Type;                    -- Pos. of mouse click, offset by camera position

begin
   
   -- Clear the game boards
   Clear_Boards(Gbs);
   
   -- Draw the grid and save this blank grid
   Draw_Grid(C);
   Save(C);
   
   -- Draw cells - kinda redundant, but you might want some test data before this point
   Draw_Board(C,Camera,Gbs(Current));
   
   -- Update the labels
   Update_Gen_Count(Gen_Count);
   Update_Camera(Camera);

   -- Keep running until the user wants to quit
   while not Exit_Game loop
      
      -- Deal with any input
      if Command_Ready then 
         case Next_Command is
            
            -- Scroll up...
            when 'U' =>
               if Camera.Y > Row_Type'First+1 then
                  Camera.Y := Camera.Y - 1;
                  Update_Camera(Camera);
                  Draw_Board(C,Camera,Gbs(Current));
               end if;
            
            -- Scroll down...
            when 'D' =>
               if Camera.Y < Row_Type'Last-1 then
                  Camera.Y := Camera.Y + 1;
                  Update_Camera(Camera);
                  Draw_Board(C,Camera,Gbs(Current));
               end if;
            
            -- Scroll left...
            when 'L' =>
               if Camera.X > Col_Type'First+1 then
                  Camera.X := Camera.X - 1;
                  Update_Camera(Camera);
                  Draw_Board(C,Camera,Gbs(Current));
               end if;
            
            -- Scroll right...
            when 'R' =>
               if Camera.X < Col_Type'Last-1 then
                  Camera.X := Camera.X + 1;
                  Update_Camera(Camera);
                  Draw_Board(C,Camera,Gbs(Current));
               end if;
            
            -- Quit...
            when 'Q' =>
               Game_Running := False;
               Exit_Game := True;
            
            -- Start/Stop...
            when 'T' =>
               Game_Running := not Game_Running;
               if Game_Running then
                  Set_Text(Btn_Toggle,"Stop");
               else
                  Set_Text(Btn_Toggle,"Start");
               end if;
            
            -- Clear...
            when 'C' =>
               -- Can only clear if game is paused
               if not Game_Running then
                  Clear_Boards(Gbs);
                  Gen_Count := 0;
                  Update_Gen_Count(Gen_Count);
                  Draw_Board(C,Camera,Gbs(Current));
               end if;
            
            -- About...
            when 'A' =>
               Show_Message("Game of Life" & ASCII.CR & "(c) 2003 Jason Frame [jasonf@btclick.com]","l33t computar game leik quake III!!!");
            
            when others =>
               null;
         
         end case;
         
         -- Mouse click on grid toggles cell status if game is not running
         if Mouse_Down(C) and not Game_Running then
            
            -- Find out what absolute cell they clicked on
            Click := ((Start_Point(C).X / Cell_Side),(Start_Point(C).Y / Cell_Side));
            
            -- Offset this by camera position to find true cell
            Mod_Click := Click + Camera;
            
            -- Toggle the cell's state
            Gbs(Current)(Mod_Click.X,Mod_Click.Y) := not Gbs(Current)(Mod_Click.X,Mod_Click.Y);
            
            -- Update the display
            Draw_Cell(C,Click.X+1,Click.Y+1,Gbs(Current)(Mod_Click.X,Mod_Click.Y));
         
         end if;
      
      end if;
      
      -- Process next game iteration if game is running
      if Game_Running then
         Do_Game(Gbs,Current);
         Current := not Current;
         Draw_Board(C,Camera,Gbs(Current));
         delay Frame_Delay;   
         Gen_Count := Gen_Count + 1;
         Update_Gen_Count(Gen_Count);
      end if;

   end loop;
      
end Game_Of_Life;