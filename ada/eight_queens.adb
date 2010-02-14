with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;

procedure Eight_Queens is
   
   -- The solution count always seems to be even
   -- Where there are X solutions, for every element of the solution:
   -- Solution(1) + Solution(X) = N + 1
   -- Solution(2) + Solution(X-1) = N + 1
   -- and so forth
   -- thus we might be able to optimise by calculating answers for only
   -- up to N/2 (rounding up), storing, and flipping the results.

   N : constant Integer := 8;
   Solution_Count : Integer := 0;
   State_Count : Integer := 0;
   
   type State_Array_Type is array(1..N) of Integer;
   State_Array : State_Array_Type := (others => 0);
   
   procedure Do_State(Start : in Integer; State : in out State_Array_Type) is
      Safe : Boolean;
      Counter : Integer;
   begin
      
      for I in 1 .. N loop
         
         -- Calculate whether or not this row is "safe"
         Safe := True;
         Counter := 1;
         while Safe = True and Counter < Start loop
            -- Check this row, and diagonals
            if (State(Start - Counter) = I) or (State(Start - Counter) = I + Counter) or (State(Start - Counter) = I - Counter) then
               Safe := False;
            end if;
            Counter := Counter + 1;
         end loop;

         -- If it's safe...
         if Safe then
            
            State_Count := State_Count + 1;

            State(Start) := I;         -- set the array
            if Start = N then             -- this means we have reached the last value, so display the solution
               Put("Solution found: ");
               for J in 1 .. N loop
                  Put(State(J),2); Put(' ');
               end loop;
               New_Line(1);
               Solution_Count := Solution_Count + 1;
            else
               -- if we're not at the end, call again
               Do_State(Start+1,State);
            end if;
         
         end if;
      end loop;
   end Do_State;
   
begin
   
   -- Go go go!!!
   Do_State(1,State_Array);
   
   -- Summary
   New_Line(1);
   Put("Finished!");
   New_Line(2);
   Put("For a "); Put(N,0); Put('x'); Put(N,0); Put(" board, I found "); Put(Solution_Count,0); Put(" solution");
   if Solution_Count /= 1 then
      Put('s');
   end if;
   Put('.');
   New_Line(1);
   Put("I considered "); Put(State_Count,0); Put(" safe partial states.");

end Eight_Queens;