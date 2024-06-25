#ifndef SENTRYSYSTEM_H
#define SENTRYSYSTEM_H

#include <sentry.h>


class SentrySystem {
public:
    SentrySystem();
    ~SentrySystem();
    void init();
    void captureExceptionFatal(const char* message);
    void captureException(const char* message);
    void captureMessage(const char* message);
    void shutdown();
    void setRelease(const char* release); 
private:
    sentry_options_t* options;
};

#endif // SENTRYSYSTEM_H
