#ifndef DISCORDRPCSYSTEM_H
#define DISCORDRPCSYSTEM_H

#include <discord_rpc.h>
#include <ctime>

static int64_t eptime = static_cast<int64_t>(std::time(nullptr));
void handleDiscordReady(const DiscordUser* request);
void initializeDiscord();
void updateRichPresence(const char* mapName);

#endif // DISCORDRPCSYSTEM_H
