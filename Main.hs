import System.IO
import qualified Network.Socket as Socket

-- | Custom Imports
import Types
import qualified Config as Config
import qualified Bot    as    Bot

config :: Config
config = Config.config

channelName :: Channel
channelName = Config.getChannelInfo config

main :: IO ()
main = do
        let (sAddr, sPort)  = Config.getServerInfo config --server addr
        let (bName, bOAuth) = Config.getBotInfo    config --bot name and oauth

        addr <- resolve sAddr $ show sPort
        sock <- open addr
        hdl  <- convertSocket sock

        Bot.doLogin     hdl bName bOAuth
        Bot.joinChannel hdl channelName

        mainLoop hdl --enter to loop
    where
        resolve host port = do
            let hints = Socket.defaultHints { Socket.addrSocketType = Socket.Stream }
            addr:_ <- Socket.getAddrInfo (Just hints) (Just host) (Just port)
            return addr
        
        open addr = do
            sock <- Socket.socket (Socket.addrFamily addr) (Socket.addrSocketType addr) (Socket.addrProtocol addr)
            Socket.connect sock $ Socket.addrAddress addr
            return sock

mainLoop :: Handle -> IO ()
mainLoop hdl = do
    res <- hGetLine hdl
    Bot.handleRes hdl res channelName
    mainLoop hdl --loop

convertSocket :: Socket.Socket -> IO Handle
convertSocket sock = do
    hdl <- Socket.socketToHandle sock ReadWriteMode
    hSetBuffering hdl NoBuffering
    return hdl
