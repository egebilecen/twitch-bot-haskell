module API (
    getClientID,
      getAPIUrl
) where

import Types
import qualified Network.Wreq as Wreq

-- | Private Variables
api_config :: API_Config
api_config = 
    API_Config
        {
            clientID = "p0gch4mp101fy451do9uod1s1x9i4a",
            apiURL   = "https://api.twitch.tv/helix/streams?game_id="
        }

-- | Public Functions
getClientID :: String
getClientID = clientID api_config

getAPIUrl   :: String
getAPIUrl   = apiURL   api_config

-- | Private Functions
