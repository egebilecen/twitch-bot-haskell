import System.IO
import qualified Network.Socket as Socket
import Control.Concurrent  (forkIO)
import Control.Monad      (forever)

-- | Custom Imports
import Types
import qualified      Config
import qualified         Bot
import qualified Interactive

channelName :: Channel
channelName = Config.getChannelInfo

main :: IO ()
main = do
        let (sAddr, sPort)  = Config.getServerInfo --server addr
        let (bName, bOAuth) = Config.getBotInfo    --bot name and oauth

        putStrLn "[?] Creating connection."

        addr <- resolve sAddr $ show sPort
        sock <- open addr
        hdl  <- convertSocket sock

        hSetEncoding hdl utf8

        Bot.doLogin     hdl bName bOAuth
        Bot.joinChannel hdl channelName
        
        putStrLn "[?] Bot activated."
        
        -- | Threading
        _ <- forkIO $ mainLoop  hdl -- Socket connection handler
        -- | _ <- forkIO $ timerLoop hdl -- Automatic command executer handler
        
        Interactive.activate  -- activate interactive mode
    where
        resolve ::             String -- sAddr
                ->             String -- sPort
                -> IO Socket.AddrInfo
        resolve host port = do
            let hints = Socket.defaultHints { Socket.addrSocketType = Socket.Stream }
            addr:_ <- Socket.getAddrInfo (Just hints) (Just host) (Just port)
            return addr
        
        open ::  Socket.AddrInfo 
             -> IO Socket.Socket
        open addr = do
            sock <- Socket.socket (Socket.addrFamily addr) (Socket.addrSocketType addr) (Socket.addrProtocol addr)
            Socket.connect sock $ Socket.addrAddress addr
            return sock
        
        convertSocket :: Socket.Socket
                      ->     IO Handle
        convertSocket sock = do
            hdl <- Socket.socketToHandle sock ReadWriteMode
            hSetBuffering hdl NoBuffering
            return hdl

mainLoop :: Handle 
         ->  IO ()
mainLoop hdl = do
    forever $  do
        res <- hGetLine hdl
        Bot.handleRes hdl res channelName

timerLoop :: Handle
          ->  IO ()
timerLoop hdl = do
    putStr "test"