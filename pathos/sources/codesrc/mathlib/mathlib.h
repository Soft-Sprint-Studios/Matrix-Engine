#ifndef MATHLIB_H
#define MATHLIB_H

#include <cmath>
#include <algorithm>
#include <numeric>

#define M_PI 3.14159265358979323846

// Basic arithmetic functions
double add(double a, double b);
double subtract(double a, double b);
double multiply(double a, double b);
double divide(double a, double b);

// Trigonometric functions
double asin(double value);
double acos(double value);
double atan(double value);

// Exponential and logarithmic functions
double exp(double x);
double log(double x);
double pow(double base, double exponent);

// Statistical functions
double mean(double* values, int size);
double median(double* values, int size);
double variance(double* values, int size);
double standard_deviation(double* values, int size);

// Vector operations
void vector_add(double* result, double* vec1, double* vec2, int size);
void vector_subtract(double* result, double* vec1, double* vec2, int size);
void vector_dot_product(double* result, double* vec1, double* vec2, int size);
double vector_magnitude(double* vec, int size);

// Matrix operations
void matrix_multiply(double** result, double** mat1, double** mat2, int rows1, int cols1, int cols2);
void matrix_add(double** result, double** mat1, double** mat2, int rows, int cols);
void matrix_subtract(double** result, double** mat1, double** mat2, int rows, int cols);

// Additional mathematical functions
double factorial(int n);
double permutation(int n, int r);
double combination(int n, int r);

// Complex number functions
struct Complex {
    double real;
    double imag;
};

Complex complex_add(Complex a, Complex b);
Complex complex_subtract(Complex a, Complex b);
Complex complex_multiply(Complex a, Complex b);
Complex complex_divide(Complex a, Complex b);
double complex_magnitude(Complex a);
Complex complex_conjugate(Complex a);

// Hypotenuse and clamp functions
double hypot(double x, double y);
double clamp(double x, double min_val, double max_val);

#endif // MATHLIB_H
