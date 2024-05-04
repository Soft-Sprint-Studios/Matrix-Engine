#include "discordrpcsystem.h"
#include <iostream>
#include <cstring>

void handleDiscordReady(const DiscordUser* request) {
    std::cout << "Discord: connected\n";
}

void initializeDiscord() {
    DiscordEventHandlers handlers;
    std::memset(&handlers, 0, sizeof(handlers));
    handlers.ready = handleDiscordReady;

    Discord_Initialize("1235165455237255238", &handlers, 1, nullptr);
}

void updateRichPresence(const char * mapName) {
    DiscordRichPresence discordPresence;
    std::memset(&discordPresence, 0, sizeof(discordPresence));

    std::string stateText = "Playing Map: ";
    if (mapName != nullptr) {
       stateText += mapName;
    }
    else {
        stateText = "In Menu";
    }
    discordPresence.state = stateText.c_str();
    discordPresence.details = "Developing Parallax Engine";
    discordPresence.startTimestamp = eptime;
    discordPresence.largeImageKey = "";
    discordPresence.largeImageText = "";
    discordPresence.smallImageKey = "";
    discordPresence.smallImageText = "";

    Discord_UpdatePresence(&discordPresence);
}
