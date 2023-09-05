#include "video_proc.hpp"
#include <vector>
#include <unistd.h>
using namespace std;
int main()
{
    // this is folder with images. Do not forget / at the end of this string
    std::string folder =
        // "Images/Completion/FalseAlarm/";
        // "Images/Completion/Theft/";
        // "Images/Challenge/";
        "Images/Core/";
    int nFrames = 20;
    // read 20 image files from specified folder
    for (int iFrame = 0; iFrame < nFrames; iFrame++)
    {
		// read pictures from the folder
        get_image_file(folder, iFrame);
        double redness = 0;
        double maxRed = 0;
        // vector keep all red pixels
        vector<pair<int, int> > red_pixels;
        // for each pixel in the picture
        for (int row = 0; row < image.height; row++)
        {
            for (int column = 0; column < image.width;
                 column++)
            {
				// calculate redness
                redness = (float)get_pixel(row, column, 0) / ((float)get_pixel(row, column, 1) + (float)get_pixel(row, column, 2));
                // keep maximum redness
                if (redness > maxRed)
                {
                    maxRed = redness;
                }
                // if redness is greater than 1 then it is red pixel and save it to vector
                if (redness > 1)
                {
                    red_pixels.push_back(make_pair(row, column));
                }
            }
        }
        int max_distances = 0;
        // for each red pixel to calculate maximum distance between red pixels
        for (int i = 0; i < red_pixels.size(); i++)
        {
            for (int j = i + 1; j < red_pixels.size(); j++)
            {
                max_distances = max(max_distances, abs(red_pixels[i].first - red_pixels[j].first) * abs(red_pixels[i].first - red_pixels[j].first) + abs(red_pixels[i].second - red_pixels[j].second) * abs(red_pixels[i].second - red_pixels[j].second));
            }
        }
        // if maximum distance is less than 5000, it means that the ruby is found
        if (max_distances < 5000)
        {
			// if max redness is greater than 1 then it means that ruby is present
            if (maxRed > 1)
            {
                cout << "Ruby present" << endl;
			}
            // else use the beep sound to alert user and print ruby was stolen
            else
            {
				cout << '\a';
                cout << "Ruby was stolen\n";
			}
        }
        else if (max_distances < 6000)
        {
			cout << '\a';
			cout << "Ruby was stolen\n";
		}
        // if max distance is greater or equal to 5000, it means that burglary is underway
        else
        {
			cout << '\a';
            cout << "Burglary is underway" << endl;
        }
        // if you want picture to be modified when displaye in browser, -do it before "save_bmp"
        save_bmp_file("m1.bmp"); // saved
        // wait 1 sec
        usleep(1e6);
        // std::this_thread::sleep_for(std::chrono::milliseconds(500)); // wait 0.5 sec // too fast
    }
    return 0;
}
