module Config (
            config,
     getServerInfo,
        getBotInfo,
    getChannelInfo
) where

import Types

config :: Config
config = 
    Config
        {
            serverInfo = ("irc.chat.twitch.tv", 6667),
            botName    = "fat_bit_bot",
            botOAuth   = "oauth:bw8cbfbkw2zjyv01e7f68wkbtko6p0",
            channel    = "fat_bit",
            commands   = [
                ("help",        "Henüz bana bunun cevabını öğretmediler."),
                ("bot_info",    "Merhaba. Ben @fat_bit tarafından Haskell dili kullanılarak yazılmış bir botum."),
                ("source_code", "Kaynak kodumu henüz daha paylaşmadılar. :(")
            ],
            autoExec   = Config_Autoexec
                            {
                                isEnabled    = True,
                                timeSec      =  300,
                                execCommands = [
                                    "help"
                                ]
                            }
        }

-- | Public Functions
getServerInfo  :: Config -> ServerInfo
getServerInfo (Config {serverInfo = a}) = a

getBotInfo     :: Config -> BotInfo 
getBotInfo (Config {botName = a, botOAuth = b}) = (a,b)

getChannelInfo :: Config -> Channel
getChannelInfo (Config {channel=a}) = a
