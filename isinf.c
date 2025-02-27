//	https://stackoverflow.com/questions/2249110/how-do-i-make-a-portable-isnan-isinf-function
//	incompatible with fast math?

int isnan(double x) { return x != x; }
int isinf(double x) { return !isnan(x) && isnan(x - x); }