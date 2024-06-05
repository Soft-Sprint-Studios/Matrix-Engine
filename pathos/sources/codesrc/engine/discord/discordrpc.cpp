#include "discordrpc.h"
#include <iostream>
#include <cstring>

void handleDiscordReady(const DiscordUser* request) {
    std::cout << "Discord: connected\n";
}

void initializeDiscord() {
    DiscordEventHandlers handlers;
    memset(&handlers, 0, sizeof(handlers));
    handlers.ready = handleDiscordReady;

    Discord_Initialize("1235165455237255238", &handlers, 1, nullptr);
}

std::string cleanMapName(const std::string& mapName) {
    std::string cleanedMapName = mapName;

    if (cleanedMapName.rfind("maps/", 0) == 0) {
        cleanedMapName.erase(0, 5);
    }

    size_t pos = cleanedMapName.rfind(".pbsp");
    if (pos != std::string::npos && pos == cleanedMapName.size() - 4) {
        cleanedMapName.erase(pos, 4);
    }

    return cleanedMapName;
}

void updateRichPresence(const char * mapName) {
    DiscordRichPresence discordPresence;
    memset(&discordPresence, 0, sizeof(discordPresence));

    std::string stateText = "Playing Map: ";
    if (mapName != nullptr) {
        std::string cleanedMapName = cleanMapName(mapName);
        stateText += cleanedMapName;
    }
    else {
        stateText = "In Main Menu";
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
