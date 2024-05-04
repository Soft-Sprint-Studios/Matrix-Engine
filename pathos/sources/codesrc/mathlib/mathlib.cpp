#include "mathlib.h"
#include <cmath>
#include <algorithm>
#include <numeric>

// Basic arithmetic functions
double add(double a, double b) {
    return a + b;
}

double subtract(double a, double b) {
    return a - b;
}

double multiply(double a, double b) {
    return a * b;
}

double divide(double a, double b) {
    if (b == 0) {
        return 0; // Return 0 when dividing by zero
    }
    return a / b;
}

// Trigonometric functions
double sin(double angle) {
    return std::sin(angle);
}

double cos(double angle) {
    return std::cos(angle);
}

double tan(double angle) {
    return std::tan(angle);
}

double asin(double value) {
    return std::asin(value);
}

double acos(double value) {
    return std::acos(value);
}

double atan(double value) {
    return std::atan(value);
}

// Exponential and logarithmic functions
double exp(double x) {
    return std::exp(x);
}

double log(double x) {
    if (x <= 0) {
        return 0; // Return 0 for non-positive values
    }
    return std::log(x);
}

double pow(double base, double exponent) {
    return std::pow(base, exponent);
}

double sqrt(double x) {
    if (x < 0) {
        return 0; // Return 0 for negative values
    }
    return std::sqrt(x);
}

// Statistical functions
double mean(double* values, int size) {
    return std::accumulate(values, values + size, 0.0) / size;
}

double median(double* values, int size) {
    std::sort(values, values + size);
    if (size % 2 == 0) {
        return (values[size / 2 - 1] + values[size / 2]) / 2;
    }
    else {
        return values[size / 2];
    }
}

double variance(double* values, int size) {
    double m = mean(values, size);
    double sum_squared_diff = 0;
    for (int i = 0; i < size; i++) {
        double diff = values[i] - m;
        sum_squared_diff += diff * diff;
    }
    return sum_squared_diff / size;
}

double standard_deviation(double* values, int size) {
    return std::sqrt(variance(values, size));
}

// Vector operations
void vector_add(double* result, double* vec1, double* vec2, int size) {
    for (int i = 0; i < size; i++) {
        result[i] = vec1[i] + vec2[i];
    }
}

void vector_subtract(double* result, double* vec1, double* vec2, int size) {
    for (int i = 0; i < size; i++) {
        result[i] = vec1[i] - vec2[i];
    }
}

void vector_dot_product(double* result, double* vec1, double* vec2, int size) {
    *result = 0;
    for (int i = 0; i < size; i++) {
        *result += vec1[i] * vec2[i];
    }
}

double vector_magnitude(double* vec, int size) {
    double sum = 0;
    for (int i = 0; i < size; i++) {
        sum += vec[i] * vec[i];
    }
    return sqrt(sum);
}

// Matrix operations
void matrix_multiply(double** result, double** mat1, double** mat2, int rows1, int cols1, int cols2) {
    for (int i = 0; i < rows1; i++) {
        for (int j = 0; j < cols2; j++) {
            result[i][j] = 0;
            for (int k = 0; i < cols1; k++) {
                result[i][j] += mat1[i][k] * mat2[k][j];
            }
        }
    }
}

void matrix_add(double** result, double** mat1, double** mat2, int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            result[i][j] = mat1[i][j] + mat2[i][j];
        }
    }
}

void matrix_subtract(double** result, double** mat1, double** mat2, int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            result[i][j] = mat1[i][j] - mat2[i][j];
        }
    }
}

double round(double x) {
    if (x < 0) {
        return std::ceil(x - 0.5);
    }
    else {
        return std::floor(x + 0.5);
    }
}

double max(double x, double y) {
    return std::max(x, y);
}

double min(double x, double y) {
    return std::min(x, y);
}

double clamp(double x, double min_val, double max_val) {
    return std::min(std::max(x, min_val), max_val);
}

double degrees_to_radians(double degrees) {
    return degrees * M_PI / 180;
}

double radians_to_degrees(double radians) {
    return radians * 180 / M_PI;
}

double mod(double a, double b) {
    if (b == 0) {
        return 0; // Return 0 when the modulus is with zero
    }
    return std::fmod(a, b);
}

double factorial(int n) {
    if (n < 0) {
        return 0; // Return 0 for negative values
    }
    double result = 1;
    for (int i = 1; i <= n; i++) {
        result *= i;
    }
    return result;
}

double permutation(int n, int r) {
    if (n < r || r < 0) {
        return 0;
    }
    return factorial(n) / factorial(n - r);
}

double combination(int n, int r) {
    if (n < r || r < 0) {
        return 0;
    }
    return factorial(n) / (factorial(r) * factorial(n - r));
}

// Complex number functions
Complex complex_add(Complex a, Complex b) {
    Complex result;
    result.real = a.real + b.real;
    result.imag = a.imag + b.imag;
    return result;
}

Complex complex_subtract(Complex a, Complex b) {
    Complex result;
    result.real = a.real - b.real;
    result.imag = a.imag - b.imag;
    return result;
}

Complex complex_multiply(Complex a, Complex b) {
    Complex result;
    result.real = a.real * b.real - a.imag * b.imag;
    result.imag = a.real * b.imag + a.imag * b.real;
    return result;
}

Complex complex_divide(Complex a, Complex b) {
    double denominator = b.real * b.real + b.imag * b.imag;
    if (denominator == 0) {
        return { 0, 0 }; // Return (0, 0) if dividing by zero
    }
    Complex result;
    result.real = (a.real * b.real + a.imag * b.imag) / denominator;
    result.imag = (a.imag * b.real - a.real * b.imag) / denominator;
    return result;
}

double complex_magnitude(Complex a) {
    return std::sqrt(a.real * a.real + a.imag * a.imag);
}

Complex complex_conjugate(Complex a) {
    Complex result;
    result.real = a.real;
    result.imag = -a.imag;
    return result;
}

// More mathematical functions as needed

