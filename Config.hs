module Config (
             config,
      getServerInfo,
         getBotInfo,
     getChannelInfo,
    getCommandsInfo
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
                -- | Normal Commands
                ("!help",        "Bot komutlarına kanal açıklamasından ulaşabilirsiniz.",                                            Nothing),
                ("!bot_info",    "Merhaba. Ben @fat_bit tarafından Haskell dili kullanılarak yazılmış bir botum.",           Just ReplyStart),
                ("!source_code", "Kaynak koduma https://github.com/egebilecen/twitch-bot-haskell adresinden ulaşabilirsin!", Just ReplyStart),
                ("!discord",     "Discord sunucumuz: https://discord.gg/bgFSaF5",                                            Just ReplyStart),
                
                -- | Special Commands
                ("!uptime",      "", Just Special)
            ],
            autoExec = 
                Config_Autoexec
                {
                    isEnabled    = True,
                    timeSec      =  300,
                    execCommands = [
                        "!help"
                    ]
                }
        }

-- | Public Functions
getServerInfo   :: ServerInfo
getServerInfo   = serverInfo config

getBotInfo      :: BotInfo 
getBotInfo      = (botName config, botOAuth config)

getChannelInfo  :: Channel
getChannelInfo  = channel config

getCommandsInfo :: [Command]
getCommandsInfo = commands config
