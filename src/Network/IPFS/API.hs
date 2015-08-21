module Network.IPFS.API where

import Control.Applicative ((<$>))
import Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.UTF8 as U
import Data.Maybe (fromJust)
import qualified Data.Text as T
import qualified Network.HTTP.Conduit as HTTP
import qualified Network.HTTP.Types.URI as URI
import Blaze.ByteString.Builder (toByteString)

call :: HTTP.Manager
     -> String
     -> [String]
     -> [(String, String)]
     -> [String]
     -> IO ByteString
call manager endpoint cmd opts args =
    HTTP.responseBody <$> HTTP.httpLbs req manager
  where path = URI.encodePathSegments . map T.pack $ ["api", "v0"] ++ cmd
        query = [(U.fromString k, Just $ U.fromString v) | (k,v) <- opts] ++
                [(U.fromString "arg", Just $ U.fromString arg) | arg <- args]
        req = (fromJust $ HTTP.parseUrl endpoint) {
            HTTP.path = toByteString path,
            HTTP.queryString = URI.renderQuery True query }
