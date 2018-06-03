module Types where

type ServerInfo  =    (String, Int)
type BotInfo     = (String, String)

type Command     = (String, String)

type BotUsername =           String
type BotOAuth    =           String

type Nickname    =           String

type Channel     =           String
type ChatMsg     =           String

type ServerRes   =           String
type ResAddr     =           String

-- | Config Data Defination
data Config_Autoexec
    = Config_Autoexec
        {
            isEnabled    ::    !Bool,
            timeSec      ::    ! Int,
            execCommands :: ![String]
        }
    deriving Show

data Config 
    = Config
        {
            serverInfo ::     !ServerInfo,
            botName    ::         !String,
            botOAuth   ::         !String,
            channel    ::         !String,
            commands   ::      ![Command],
            autoExec   :: !Config_Autoexec
        }
    deriving Show
