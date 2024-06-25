#include "sentrysystem.h"

SentrySystem::SentrySystem() {
    options = sentry_options_new();
}

SentrySystem::~SentrySystem() {
    sentry_options_free(options);
}

void SentrySystem::init() {
    sentry_options_set_dsn(options, "https://c3ce4f569b8f43507d999deb88a64678@o4505736231124992.ingest.us.sentry.io/4507239020494848");
    sentry_options_set_database_path(options, ".sentry-native");
    sentry_options_set_release(options, "Matrix Engine");
    sentry_options_set_debug(options, 1);
    sentry_init(options);
}

void SentrySystem::captureExceptionFatal(const char* message) {
    sentry_capture_event(sentry_value_new_message_event(SENTRY_LEVEL_FATAL, "sentry_fatal", message));
}

void SentrySystem::captureException(const char* message) {
    sentry_capture_event(sentry_value_new_message_event(SENTRY_LEVEL_ERROR, "sentry_error", message));
}

void SentrySystem::captureMessage(const char* message) {
    sentry_capture_event(sentry_value_new_message_event(SENTRY_LEVEL_INFO, "sentry_info", message));
}

void SentrySystem::shutdown() {
    sentry_close();
}

void SentrySystem::setRelease(const char* release) {
    sentry_options_set_release(options, release);
}