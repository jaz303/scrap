#include <SDL2/SDL.h>
#include <SDL2/SDL2_gfxPrimitives.h>

#include "math.h"
#include "time.h"

const int MAP_WIDTH = 40;
const int MAP_HEIGHT = 40;

const int HEX_HEIGHT = 32;
const int HEX_WIDTH = HEX_HEIGHT;
const int HEX_SLOPE = 8;

const int HEX_HALF_HEIGHT = HEX_HEIGHT / 2;
const int HEX_HALF_WIDTH = HEX_WIDTH / 2;
const int HEX_BOX_HALF_WIDTH = (HEX_WIDTH - (2 * HEX_SLOPE)) / 2;
const int HEX_X_INC = HEX_WIDTH - HEX_SLOPE;

int map[MAP_WIDTH * MAP_HEIGHT];
int colors[4] = {
	0xff0000ff,
	0xffff0000,
	0xffff00ff,
	0xff00ff00
};

SDL_Surface *surface;
SDL_Renderer *renderer;

void drawMap() {
	int x = 0, y = 0;
	int currX = x;

	int maxX = (800 / HEX_X_INC) + 1;
	int maxY = (600 / HEX_HEIGHT) + 1;

	for (int i = 0; i < maxX; ++i) {
		int currY = y - (i & 1) ? HEX_HALF_HEIGHT : 0;
		for (int j = 0; j < maxY; ++j) {
			int type = map[(j * MAP_WIDTH) + i];
			int color = colors[type];
			
			Sint16 xs[6] = {
				currX - HEX_BOX_HALF_WIDTH,
				currX + HEX_BOX_HALF_WIDTH,
				currX + HEX_HALF_WIDTH,
				currX + HEX_BOX_HALF_WIDTH,
				currX - HEX_BOX_HALF_WIDTH,
				currX - HEX_HALF_WIDTH
			};
			Sint16 ys[6] = {
				currY - HEX_HALF_HEIGHT,
				currY - HEX_HALF_HEIGHT,
				currY,
				currY + HEX_HALF_HEIGHT,
				currY + HEX_HALF_HEIGHT,
				currY
			};
			filledPolygonColor(renderer, xs, ys, 6, color);
			currY += HEX_HEIGHT;
		}
		currX += HEX_X_INC;
	}
}

int main(int argc, char *argv[]) {

	srand(time(NULL));

	SDL_Init(SDL_INIT_VIDEO);
	SDL_Window *window = SDL_CreateWindow("hexworld", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 800, 600, 0);

	renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
	if (!renderer) {
		printf("error creating renderer\n");
		return 1;
	}

	printf("generating map...\n");
	for (int i = 0; i < MAP_HEIGHT; ++i) {
		for (int j = 0; j < MAP_WIDTH; ++j) {
			map[(i * MAP_WIDTH) + j] = rand() % 4;
		}
	}

	while (1) {
        SDL_Event e;
        if (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT) {
                break;
            }
        }
        SDL_SetRenderDrawColor(renderer, 0x00, 0x00, 0x00, 0xff);
		SDL_RenderClear(renderer);

		Uint32 now = SDL_GetTicks();
		drawMap();
		printf("rendered: %dms\n", SDL_GetTicks() - now);

        SDL_RenderPresent(renderer);
        SDL_Delay(1000 / 30);
    }

	SDL_DestroyWindow(window);
	SDL_Quit();

	return 0;

}