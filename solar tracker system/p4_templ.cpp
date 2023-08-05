#include <algorithm>
#include <chrono>
#include <cmath>
#include <random>
#include <thread>
// line 131 is where init() located
#include "image_pr4.h"

using namespace std;

int v[1000][1000];

// you can use that
struct Orbit {
  // logged position and time
  std::vector<int> x;
  std::vector<int> y;
  std::vector<int> t;
  int xc, yc, r;             // center and radius
  int x_sunrise, y_sunrise;  // aim position
  double omega = 0.1;
} orbit;

typedef pair<int, int> point;

int index(vector<point> arr, point p) {
  for (int i = 0; i < arr.size(); i++) {
    if (arr[i] == p) return i;
  }
  return -1;
}
int index(vector<int> arr, int p) {
  for (int i = 0; i < arr.size(); i++) {
    if (arr[i] == p) return i;
  }
  return -1;
}

point calculate_center(double x1, double y1, double x2, double y2, double x3,
                       double y3) {
  double a = 2 * (x1 - x2);
  double b = 2 * (y1 - y2);
  double c = x2 * x2 - x1 * x1 + y2 * y2 - y1 * y1;
  double d = 2 * (x1 - x3);
  double e = 2 * (y1 - y3);
  double f = x3 * x3 - x1 * x1 + y3 * y3 - y1 * y1;

  double x = (f * b - c * e) / (a * e - b * d);
  double y = (-a * f + c * d) / (a * e - b * d);
  return make_pair(x, y);
}

void dfs(int x,int y,int &score)
{
    if(x<0 || x>=image.width || y<0 || y>=image.height)
        return;
    if(v[x][y] == 1)
        return;
    v[x][y]=1;
    double redness = (float)get_pixel(image, x, y, 0) /
                          ((float)get_pixel(image, x, y, 1) +
                          (float)get_pixel(image, x, y, 2));
    if (redness > 1) {
      score++;
    }
    else{
        return;
    }
    dfs(x+1,y,score);
    dfs(x-1,y,score);
    dfs(x,y+1,score);
    dfs(x,y-1,score);
}

point get_red_coor() {
  int size = 14;
  int max = 0;
  for (int i = 0; i < image.width; i++) {
    for (int j = 0; j < image.height; j++) {
      v[i][j] = 0;
    }
  }
  for (int row = size; row < image.height - size; row++) {
    for (int column = size; column < image.width - size; column++) {
      int count = 0;
      dfs(column,row,count);
      if(count<=609 && count>=100)
      {
        return make_pair(row+14,column+14);
      }
    }
  }
  // night time
  return make_pair(-1, -1);
}

bool is_tracked(point p, int x_sun, int y_sun) {
  int x = x_sun;
  int y = y_sun;
  return (abs(x - p.first) < 95 / 4) && (abs(y - p.second) < 95 / 4);
}

bool is_night(int x_sun, int y_sun) { return x_sun == -1 && y_sun == -1; }

void move_aim_to_sun(point *curr, int x_sun, int y_sun) {
  while (1) {
    int x = curr->first;
    int y = curr->second;
    int dx, dy;
    if (is_night(x_sun, y_sun)) {
      // dx = (orbit.x_sunrise - x);
      // dy = (orbit.y_sunrise - y);
      break;
    } else {
      dx = (x_sun - x);
      dy = (y_sun - y);
    }
    // move aim to the sun

    double theta = atan2(dy, dx);
    move_aim(theta);
    curr->first = x + 30 * cos(theta);
    curr->second = y + 30 * sin(theta);
    if (is_tracked(*curr, x_sun, y_sun)) break;
  }
  cout << "_____________" << endl << endl;
}

int main() {
  std::cout << "start..." << std::endl;
  init(2); // init(0) : core // init(1) : comp // init(2) : challenge

  int x_sun, y_sun;  // current position of the sun
  int row = image.height;
  int col = image.width;
  //   int acc[row][col];
  point prev;
  point curr_aim = make_pair(450, 450);

  // for (int i = 0; i < row; i++) {
  //   for (int j = 0; j < col; j++) {
  //     acc[i][j] = 0;
  //   }
  // }
  for (int time = 0; time < 950; time++) {
    draw_all(time);
    point sun_coor = get_red_coor();

    x_sun = sun_coor.first;
    y_sun = sun_coor.second;

    if (x_sun != -1 and y_sun != -1 && prev.first == -1 and prev.second == -1) {
      orbit.x_sunrise = x_sun;
      orbit.y_sunrise = y_sun;
    }
    prev.first = x_sun;
    prev.second = y_sun;

    if (!(x_sun == -1 && y_sun == -1) ){
      orbit.x.push_back(x_sun);
      orbit.y.push_back(y_sun);
      orbit.t.push_back(time);
    }
    vector<int> random_point;
    if (time == 60) {
      for (int i = 0; i < 20; i++) {
        random_point.push_back(rand() % orbit.t.size());
      }

      // make point using x and y
      vector<point> points;
      for (auto i : random_point) {
        int ind = index(orbit.t, i);
        if (ind == -1) continue;
        // cout << "yess ______________________" << endl;
        points.push_back(make_pair(orbit.x[ind], orbit.y[ind]));
      }

      vector<point> center_collection;
      for (int i = 0; i < points.size(); i++) {
        for (int j = i + 1; j < points.size(); j++) {
          for (int k = j + 1; k < points.size(); k++) {
            point center = calculate_center(
                points.at(i).first, points.at(i).second, points.at(j).first,
                points.at(j).second, points.at(k).first, points.at(k).second);
            center_collection.push_back(center);
          }
        }
      }

      // find the most common center
      int max = 0;
      point center;
      for (auto i : center_collection) {
        int count = 0;
        for (auto j : center_collection) {
          if (i == j) count++;
        }
        if (count > max) {
          max = count;
          center = i;
        }
      }

      orbit.xc = center.first;
      orbit.yc = center.second;
      orbit.r = sqrt(pow(orbit.xc - orbit.x_sunrise, 2) +
                     pow(orbit.yc - orbit.y_sunrise, 2));
    }

    cout << " time=" << time << endl;
    move_aim_to_sun(&curr_aim, x_sun, y_sun);
    this_thread::sleep_for(chrono::milliseconds(500));
  }
  return 0;
}
