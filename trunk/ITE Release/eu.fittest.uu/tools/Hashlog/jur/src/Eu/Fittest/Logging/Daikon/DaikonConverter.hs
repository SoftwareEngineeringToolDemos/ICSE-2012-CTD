{- 

Author: Wishnu Prasetya

Copyright 2011 Utrecht University

The use of this sofware is free under the Modified BSD License.

-}

{- | 

   This module provides functions to convert compressed raw 
   log to Daikon log.
     
-}

{-# LANGUAGE BangPatterns #-}

module Eu.Fittest.Logging.Daikon.DaikonConverter(
     saveAsDaikonLog,
     showAsDaikonLog 
  )

where

import Debug.Trace
import Data.List
import System.IO
import System.FilePath
import Eu.Fittest.Logging.XML.Value
import Eu.Fittest.Logging.XML.Event
import Eu.Fittest.Logging.XML.AppEvent
import Eu.Fittest.Logging.XML.LowEvent
import Eu.Fittest.Logging.XML.EventLog
import Eu.Fittest.Logging.XML.Base
import Eu.Fittest.Logging.Compression.RawlogParser
import Eu.Fittest.Logging.Compression.Compress
import Eu.Fittest.Logging.Compression.Serializer
import Eu.Fittest.Logging.Daikon.DaikonAST


{- =============================================================

   Intermediate data-types to make the conversion from FITTEST
   to Daikon easier.
   
============================================================= -}
 
data XDaikonRecord =  XDaikonRecord {
       -- program point's name
       xdrPptName :: String,
       -- values logged at that program point in: var-path, type, value
       xdrValues  :: [([String],XType,String,DaikonValue)]
    }                  
    deriving (Show,Eq) 
   
data XType = DaikonType_  DaikonType
           | XClassName_
           deriving (Show,Eq) 

-- path, declared-type, daikon xtype
type XVarDecl = ([String],String,XType)

         
{- =============================================================

   Converting XDaikonRecord to DaikonRecord. Array is not handled
   yet!!
   
============================================================= -}           
              
-- converting xdaikon-record to daikon-record.           
xdaikonRecord2daikon 
   nonce 
   (XDaikonRecord { xdrPptName=name, xdrValues=vars })
   =
   DaikonRecord {
       drPptName =name ,
       drNonce = nonce,
       -- values logged at that point in: var-name, value, modified-flag
       drValues = map f vars 
    }    
    
   where
   f (varpath,_,_,Single Nonsesical) = (mkVarName varpath,Single Nonsesical,2)
   f (varpath,_,_,val) = (mkVarName varpath,val,1)
    
mkVarName varpath = concat . intersperse "." . reverse $ varpath
  
-- converting xdaikon-var-declaration to daikon version.
--  
xVarDecl2daikonVarDecl (varpath,orgty,xtype) 
    =
    case xtype of
       XClassName_  ->  VarDecl {
                  vName = vname,
                  vEnclosingVar = Nothing,
                  varKind = VkVariable,
                  varOrgType = orgty,
                  varType = SimpleType_ String_,
                  vComparability = "29", 
                  vParent = Nothing,                 
                  arrayDim = Nothing,
                  vFlags = [IsClassName]
                }
                
       DaikonType_  t@(SimpleType_ Bool_) -> VarDecl {
                  vName = vname,
                  vEnclosingVar = Nothing,
                  varKind = VkVariable,
                  varOrgType = orgty,
                  varType = t,
                  vComparability = "1",   
                  vParent = Nothing,                   
                  arrayDim = Nothing,
                  vFlags = []
                }

       DaikonType_  t@(SimpleType_ Int_) -> VarDecl {
                  vName = vname,
                  vEnclosingVar = Nothing,
                  varKind = VkVariable,
                  varOrgType = orgty,
                  varType = t,
                  vComparability = "2",   
                  vParent = Nothing,                   
                  arrayDim = Nothing,
                  vFlags = []
                }  

       DaikonType_  t@(SimpleType_ Double_) -> VarDecl {
                  vName = vname,
                  vEnclosingVar = Nothing,
                  varKind = VkVariable,
                  varOrgType = orgty,
                  varType = t,
                  vComparability = "3",  
                  vParent = Nothing,                   
                  arrayDim = Nothing,
                  vFlags = []
                }     

       DaikonType_  t@(SimpleType_ String_) -> VarDecl {
                  vName = vname,
                  vEnclosingVar = Nothing,
                  varKind = VkVariable,
                  varOrgType = orgty,
                  varType = t,
                  vComparability = "4", 
                  vParent = Nothing,                   
                  arrayDim = Nothing,
                  vFlags = []
                }     
                
       DaikonType_  t@(SimpleType_ Hash_) -> VarDecl {
                  vName = vname,
                  vEnclosingVar = Nothing,
                  varKind = VkVariable,
                  varOrgType = orgty,
                  varType = t,
                  vComparability = "5",  
                  vParent = Nothing,                   
                  arrayDim = Nothing,
                  vFlags = []
                }                 

       DaikonType_  t@(Array_ Bool_) -> VarDecl {
                  vName = vname,
                  vEnclosingVar =  Just vparent,
                  varKind = VkArray,
                  varOrgType = orgty,
                  varType = t,
                  vComparability = "11[51]",   -- 11[1] is refused by Daikon, so I am changing it!
                  vParent = Nothing,                   
                  arrayDim = Just 1,
                  vFlags = []
                }

       DaikonType_  t@(Array_ Int_) -> VarDecl {
                  vName = vname,
                  vEnclosingVar = Just vparent,
                  varKind = VkArray,
                  varOrgType = orgty,
                  varType = t,
                  vComparability = "12[52]",  
                  vParent = Nothing,                   
                  arrayDim = Just 1,
                  vFlags = []
                }  

       DaikonType_  t@(Array_ Double_) -> VarDecl {
                  vName = vname,
                  vEnclosingVar = Just vparent,
                  varKind = VkArray,
                  varOrgType = orgty,
                  varType = t,
                  vComparability = "13[53]", 
                  vParent = Nothing,                   
                  arrayDim = Just 1,
                  vFlags = []
                }     

       DaikonType_  t@(Array_ String_) -> VarDecl {
                  vName = vname,
                  vEnclosingVar = Just vparent,
                  varKind = VkArray,
                  varOrgType = orgty,
                  varType = t,
                  vComparability = "14[54]",  
                  vParent = Nothing,                   
                  arrayDim = Just 1,
                  vFlags = []
                }     
                
       DaikonType_  t@(Array_ Hash_) -> VarDecl {
                  vName = vname,
                  vEnclosingVar = Just vparent,
                  varKind = VkArray,
                  varOrgType = orgty,
                  varType = t,
                  vComparability = "15[55]",   
                  vParent = Nothing,                   
                  arrayDim = Just 1,
                  vFlags = []
                }                                 
    where
    vname = mkVarName varpath  
    vparent = case varpath of
                (_:_:_)  -> mkVarName (tail varpath)
                _        -> error "the parent-path to a var name is empty..."
  
   
{- =============================================================

   Converting sequence of FITTEST events to Daikon log. Currently
   only conversion of high level events are supported.
   
   Note: well... by encoding low level events as high level
   events we can also handle them.
============================================================= -}           
          
{- | This converts a FITTEST log to a Daikon log. The string is
     the name/path to the FITTEST log. It consumes a compressed
     log, not the raw log (so you must have covert the .log file
     to the pair .lox and .dic). The function creates .dtrace file.
-}        
saveAsDaikonLog :: String -> IO()
saveAsDaikonLog file = do {
    (dict,log1) <- loadCompressedLog file ;
    let
    log2      = decompressTimeStamp log1
    events    = uncurry (topRunCLparser parseEventLog) (dict,log2) 
    daikonLog = showAsDaikonLog events
    basef     = dropExtension file
    daikonf   = addExtension basef "dtrace"
    in 
    -- putStr daikonLog
    writeFile daikonf daikonLog
   }

{- | This converts a sequence of events to a Daikon log (in the 
     resulting string).
-}   
showAsDaikonLog :: [Event_] -> String
showAsDaikonLog events = concat_ [header, decls_ , records_]
   where
   header = "decl-version 2.0\n\n"
   decls_    =  concat_ . map dpp $ decls
   records_  =  concat_ . map dpp $ records
   concat_   =  concat . intersperse "\n\n"   
   (decls,records) = toDaikonLog_ events
        
toDaikonLog_ :: [Event_] -> ([Ppt],[DaikonRecord])   
toDaikonLog_ events = ( [appTopPpt,initStatePpt] ++ appEventsPpts,
                        records ) 
    where
    entries = [ convertAppEventTuple r | r <- restructureLog events ]
    
    -- get the entries that belonging to app's states
    states = let
             preStates  = concat [ s | (s,_,_,_,_) <- entries ]
             postStates = concat [ s | (_,_,_,s,_) <- entries ]
             in
             take 1 preStates ++ postStates
             
    -- get the entries that belonging to app's first state 
    initState :: [([String], XType, String, DaikonValue)]   
    initState = concat [ s | (s,_,_,_,_) <- take 1 entries ]
    
    -- extract the declarations of variables in app's abs-state
    stateVarsDecls_ :: [XVarDecl]
    stateVarsDecls_ = extractDaikonVarDecls states
    stateVarsDecls  :: [VarDecl]
    stateVarsDecls  = fixComparability 100 [ xVarDecl2daikonVarDecl d | d <- stateVarsDecls_ ]
    
    -- extract all the event-names and the declarations of their 
    -- arguments; also numbering them.
    eventArgsDecls_ :: [(Int,(String,[XVarDecl]))]
    eventArgsDecls_ = zip [0..] (worker entries)
       where
       worker [] = []
       worker ((_,eName,args,_,_) : z) = (eName,decls) : worker z2
           where
           argZ = concat [ getArgs r | r <- z1 ]
           (z1,z2) = partition (likeMe eName) z
           --argZ = concat [ getArgs r | r <- z, likeMe eName r ]
           -- z2   = filter (not . likeMe eName) z
           decls = [ d | d <- extractDaikonVarDecls (args ++ argZ) ]
  
       likeMe n1 (_,n2,_,_,_) = n2==n1
       getArgs (_,_,args,_,_) = args
     
    eventArgsDecls :: [(Int,String,[VarDecl])] 
    eventArgsDecls  = [ (i,ename, map xVarDecl2daikonVarDecl decls) 
                         | 
                         (i,(ename,decls)) <- eventArgsDecls_ ]
    
    -- get the args-declrations of a given event
    getArgsDecls :: String -> [XVarDecl]
    getArgsDecls name = case find (\(_,(n,_))-> n==name) eventArgsDecls_ of
        Just (_,(_,decls))  ->  decls
        _  ->  []
    
    
    -- constructing the top-level program point declaration  
    appTopPpt :: Ppt    
    appTopPpt = Ppt 
        { pptName = "App:::OBJECT",
          pptType = Object_,
          pptParent = Nothing,
          varDecls = stateVarsDecls
        }      
          
    -- constructing the declaration of each event as a Daikon
    -- program point.   
    appEventsPpts :: [Ppt]
    appEventsPpts = concat [ make r | r <- eventArgsDecls ]
       where
       make (id,fn,argsDecls) = [enterPpt,exitPpt]
          where
          argsDecls_ = fixComparability (100 + length stateVarsDecls)  . map (addFlag IsParam) $ argsDecls
          stateVarsDecls2 = map (addParentPpt ("App:::OBJECT",relId)) stateVarsDecls
          relId = show (10 + id)
          
          enterPpt = Ppt 
              { pptName = fn ++ ":::ENTER",
                pptType = Enter_,
                pptParent = Nothing,
                varDecls  = argsDecls_ ++ stateVarsDecls
              }
              
          exitPpt = Ppt 
              { pptName = fn ++ ":::EXIT1",
                pptType = Exit_,
                pptParent = Just ("parent","App:::OBJECT",relId),
                varDecls = argsDecls_ ++ stateVarsDecls2
              }

    -- constructing the declaration of the initial state
    initStatePpt :: Ppt
    initStatePpt = Ppt { 
       pptName = "AppInit:::POINT",
       pptType = Point_,
       pptParent = Just ("parent","App:::OBJECT",relId),
       varDecls  = map (addParentPpt ("App:::OBJECT",relId)) stateVarsDecls
    }     
    relId = "1"
             
    -- constructing the X-records that corresponds to the initial state 
    xinitState :: [XDaikonRecord]
    xinitState = if null initState then []
                 else [ XDaikonRecord {
                           xdrPptName = "AppInit:::POINT" ,
                           xdrValues  = reorderVarValues stateVarsDecls_ initState
                        } ]
    
    -- constructing the X-records that correspond to the rest of the log
    xrecords_ :: [(XDaikonRecord,XDaikonRecord)]
    xrecords_ =  map convert $ entries
    convert (s0,ename,args,s1,lowEvs) = (rEnter,rExit)
       where
       rEnter = XDaikonRecord {
                   xdrPptName = ename ++ ":::ENTER",
                   xdrValues  = reorderVarValues xvardecls (args ++ s0)
               }    
               
       xvardecls = getArgsDecls ename ++ stateVarsDecls_          
  
       rExit = XDaikonRecord {
                   xdrPptName = ename ++ ":::EXIT1",
                   xdrValues  = reorderVarValues xvardecls (args ++ s1)
               } 
               
               
    -- finally, constructing the daikon records that correspond to the log
    records :: [DaikonRecord]
    records = map (xdaikonRecord2daikon "0") xinitState
              ++
              convert1 1 xrecords_
              
    convert1 k []    = []
    convert1 k ((e,ex):z) =   xdaikonRecord2daikon (show k)  e
                            : xdaikonRecord2daikon (show k)  ex
                            : convert1 (k+1) z
  
               
-- add a flag to a var-declaration
--
addFlag flag (VarDecl {
                  vName = name  ,
                  vEnclosingVar = ename,
                  varKind = kind,
                  varOrgType = oty,
                  varType = ty,
                  vComparability = c,    
                  vParent = p ,                  
                  arrayDim = dim,
                  vFlags = flags
                })
      =
      VarDecl {
                  vName = name  ,
                  vEnclosingVar = ename,
                  varKind = kind,
                  varOrgType = oty,
                  varType = ty,
                  vComparability = c,    
                  vParent = p ,                  
                  arrayDim = dim,
                  vFlags = flag : flags
                }

-- extend a var-declaration with a parent ppt.
--               
addParentPpt parentPpt (VarDecl {
                  vName = name  ,
                  vEnclosingVar = ename,
                  varKind = kind,
                  varOrgType = oty,
                  varType = ty,
                  vComparability = c,    
                  vParent = _ ,                  
                  arrayDim = dim,
                  vFlags = flags
                })
      =
      VarDecl {
                  vName = name  ,
                  vEnclosingVar = ename,
                  varKind = kind,
                  varOrgType = oty,
                  varType = ty,
                  vComparability = c,    
                  vParent = Just parentPpt ,                  
                  arrayDim = dim,
                  vFlags = flags
                }
            
--
-- Fix the comparability of var-declarations so that Virtual variables are made non-
-- comparable to each other, and to other variables.
-- 
fixComparability startingCounter vardecls = map fix (zip [startingCounter..] vardecls)
   where
   isVirtual name = any (\s-> s `isSuffixOf` name) ["__isNull", "__isUndefined","__type","__elemTypes"]
   isArray (Array_ _) = True
   isArray _ = False
   
   fix (k, d@(VarDecl {
                  vName = name  ,
                  vEnclosingVar = ename,
                  varKind = kind,
                  varOrgType = oty,
                  varType = ty,
                  vComparability = c,    
                  vParent = p ,                  
                  arrayDim = dim,
                  vFlags = flags
                })) 
        =
        if not(isVirtual name) then d
        else let
             cx = if isArray ty then "show k" ++ "[" ++ show k ++ "]" else show k
             in
             (VarDecl {
                  vName = name  ,
                  vEnclosingVar = ename,
                  varKind = kind,
                  varOrgType = oty,
                  varType = ty,
                  vComparability = cx,    
                  vParent = p ,                  
                  arrayDim = dim,
                  vFlags = flags
                })  
                
                

-- 
-- Restructure FITTEST log to a list of (s0,e,s1,lows) where
--    e  is a high event
--    s0 is the abstract state before the event
--    s1 is the abstract state after the event
--    lows are the sequence of low events triggered by e
--
restructureLog :: [Event_] -> [( Value_, AppEvent_, Value_,LowLevelInfo)]
restructureLog z = if null z1 then []
                   else worker firstHighEvent theRest
         
   where
   -- discard the first series of low level events...
   z1 = dropWhile isLowEvent z
   firstHighEvent = toAppEvent (head z1)
   theRest        = tail z1

   worker e s = if null s2 then []
                else (preState_, nextHighEvent, postState, lowEvents)
                     : worker nextHighEvent theRest
     where
     -- get preceeding low-events
     (lowEvents_,s2) =  span isLowEvent s
     preState        =  avoidXID0 (aeSmodel e)
     postState       =  avoidXID0 (aeSmodel nextHighEvent)
     preState_       =  renumberXID (maxXID postState + 1) preState
     lowEvents       =  map toLowEvent lowEvents_
     nextHighEvent   =  toAppEvent (head s2)
     theRest         =  tail s2
 

-- Increase the XIDs by 1 so that 0 does not occur as XID. XID 0 has no
-- special meaning, but Daikon interprets hash 0 as null.
avoidXID0 = renumberXID 1

type LowLevelInfo = [LowEvent_]
 
isLowEvent (LE _) = True
isLowEvent  _     = False
toAppEvent (AE e) = e
toLowEvent (LE e) = e

--
-- Converting an event tuple produced by restructureLog to a tuple
-- of (s1,en,args,s2,lowEvents) where:
--
--    s1 and s2 are var-val entries of the pre and post states 
--              of the event tuple
--    
--    en   is the event name
-- 
--    args  are var-val entries of the event's arguments.
--
--    lowEvents are converted lowEvents... currently left undefined.
--
convertAppEventTuple (preState, appEvent, postState, lowEvents)
   =
   (s1,ename, concat args_ ,s2, undefined)  
   where
   s1 = convertSmodel preState
   s2 = convertSmodel postState
   ename  = eventName
               ++  "_" 
               ++  targetId
               ++  "(..)"
   args_   = zipWith f [0..] (getAppEventArgs appEvent)
   f i x   = convertArg ("arg" ++ show i) (avoidXID0 x)
   eventName = case getAppEventName appEvent of
                 Just n -> n
                 _      -> "unidentifiedEvent"
              
   targetId = case getAppEventTargetID appEvent of
                 Just i -> i
                 _  -> "unindentified-target"

   
--   
-- To reorder VarValues so that they appear in the same order
-- as in the declarations
--
reorderVarValues decls values = map f decls
   where
   f (name,orgty,ty) = case find (\(n,_,_,_)-> n==name) values of
                         Just v -> v
                         _      -> (name,ty,orgty,Single Nonsesical)
                 

--    
-- extracting var-declarations from a list of FITTEST abstract states.
--
extractDaikonVarDecls :: [([String], XType, String, DaikonValue)] -> [XVarDecl]
extractDaikonVarDecls values 
   = 
   removeDuplicates 
   . removeDynamicVars  
   $ 
   [(n,oty,ty) | (n,ty,oty,val) <- values ]
   where
   
   removeDuplicates []  = []
   removeDuplicates (d@(n,oty,ty) : z) = d : removeDuplicates (filter p z)
      where
      p (n2,_,_) = n2 /= n

      
-- In daikon every variable must have the same Daikon-type through
-- out the execution; so we remove variables whose Daikon-types change
-- dynamically:
removeDynamicVars_ [] = []
removeDynamicVars_ (d@(n,_,ty) :  decls) =
   if conflicting 
      then removeDynamicVars (filter p decls)
      else d : removeDynamicVars decls
   where
   conflicting = any (\(n2,_,ty2)-> (n==n2) && (ty /= ty2)) decls
   p (n2,_,ty2)  = n2/=n
 
removeDynamicVars decls = worker ([],[]) decls
   where
   worker (_,collected) [] = collected
   worker (conflicting,collected) (d:decls) =
     if n2 `elem` conflicting
        then worker (conflicting,collected) decls
        else  if newConflict 
                 then worker (conflicting2,collected2) decls
                 else if any (sameNameAs n2) collected
                      then worker (conflicting, collected) decls
                      else worker (conflicting, d : collected) decls                 

     where
     (n2,_,ty2) = d
     newConflict  = any (\(n1,_,ty1)-> (n1==n2) && (ty1 /= ty2)) collected
     conflicting2 = n2 : conflicting
     collected2   = filter (not . sameNameAs n2) collected
     sameNameAs n = (\(n1,_,_)-> n==n1)
     
 
 
--
-- Converting an smodel object in FITTEST log to Daikon. It returns a list of
-- tuples (p,dty,oty,val); each representing a subobject o of the smodel. 
--
-- Here, p is tha field-path to o, dty is its daikon-type, oty is its 
-- original type, and val is the daikon value that represents it.
--
convertSmodel :: Value_ -> [([String], XType, String, DaikonValue)]
convertSmodel val = convertVal_ (buildXREFmap val) ["smodel"] val
 
mkIsNullVirtualVar varpath bool = convertBasicVal varpath' ("Boolean",b)
   where
   varpath' =  "__isNull" : varpath
   b   = if bool then "true" else "false"
    
mkIsUndefinedVirtualVar varpath bool = convertBasicVal varpath' ("Boolean",b) 
   where
   varpath' =  "__isUndefined" : varpath   
   b   = if bool then "true" else "false"
   
mkPointerField varpath id = (
         varpath,
         DaikonType_ (SimpleType_ Hash_),
         "XID",
         Single . Val1 . show $ id )
    
mkTheTypeVirtualVar varpath cname = (
          "__type" : varpath, 
          XClassName_ , 
          "Virtual_Type", 
          Single . Val1 . show $ cname )
          
mkArrayElemsTypes varpath types = (
          "__elemsTypes" : varpath, 
          DaikonType_ (Array_ String_) , 
          "Virtual_Type[]", 
          Multiple [ Val1 . show $ ty | ty <- types ] )          
 
--
-- The worker function of convertSmodel
--
 
-- Skip fields marked as ID; this is logger's injected info 
convertVal_ xREFmap varpath val@(SingleVal_ { vVal=v, vTy="ID" }) = [] 
--          
convertVal_ xREFmap varpath val@(SingleVal_ { vVal=v, vTy=ty }) 
   =
   [mkTheTypeVirtualVar varpath ty]
   ++ mkIsNullVirtualVar varpath isNull_ 
   ++ mkIsUndefinedVirtualVar varpath isUndefined_
   ++ val'
   where
   val' = if isNull_ || isUndefined_ || isUnserializable val
          then {- remove entry if it is null or undefined;
                  this will be eventually be translated to "nonsensical"
                  in Daikon, which it will ignore.
                -}
                [] 
          else convertBasicVal varpath (ty,v) 
   isNull_      = isNull val
   isUndefined_ = isUndefined val
   
             
convertVal_  xREFmap varpath val@(Obj_   { ocname = cname , ofields = fields })
   =
   xid 
   ++ mkIsNullVirtualVar varpath False
   ++ mkIsUndefinedVirtualVar varpath False
   ++ val_
      
   where
   xid = case getXID val of
           Just id -> [ mkPointerField varpath id ]
           _       -> []
      

   val_ = if isArray val then convertArray_ xREFmap varpath val
          else if isCollection val then convertCollection_ xREFmap varpath val
          else if isDictionary val then convertDictionary_ xREFmap varpath val
          else -- plain object:
               [mkTheTypeVirtualVar varpath cname] ++ subvars
    
    
   subvars = concat . map (convertField xREFmap varpath) $ fields
   
convertBasicVal varpath (ty,v) =
   case ty of
     "int"     ->  [(varpath, DaikonType_ (SimpleType_ Int_)    , ty, val_ v)]
     "Boolean" ->  [(varpath, DaikonType_ (SimpleType_ Bool_)   , ty, bval_ v)]
     "Number"  ->  [(varpath, DaikonType_ (SimpleType_ Double_) , ty, val_ v)]
     "String"  ->  [(varpath, DaikonType_ (SimpleType_ String_) , ty, val_ v)]
     -- other (wierd) types like void and Null are taken care of elsewhere
     _         ->  []     

val_  v  =  Single (Val1 v)
bval_ v  =  if (v=="true") then val_ "1" else val_ "0"
bval__ v =  if (v=="true") then Val1 "1" else Val1 "0"
   
convertArray_  xREFmap varpath a
   =
   theArray ++ [mkArrayElemsTypes varpath elemsTypes]
   where
   elemsTypes = getArrayElemsTypes xREFmap a
   elems  = Multiple [Val1  . vVal $ x  | x <- getArrayElems xREFmap a]
   belems = Multiple [bval__ . vVal $ x | x <- getArrayElems xREFmap a]
   varpath_ = "__array" : varpath
  
   theArray = case nub elemsTypes of
     ["int"]     ->  [(varpath_, DaikonType_ (Array_ Int_), "int[]", elems)]
     ["Number"]  ->  [(varpath_, DaikonType_ (Array_ Double_), "Number[]", elems)]
     ["Boolean"] ->  [(varpath_, DaikonType_ (Array_ Bool_), "Boolean[]", belems)]
     ["String"]  ->  [(varpath_, DaikonType_ (Array_ String_), "String[]", elems)]
     _           ->  []
  
  
convertCollection_  xREFmap varpath c
   =
   theCol ++ [mkArrayElemsTypes varpath elemsTypes]
   where
   elemsTypes = getCollectionElemsTypes xREFmap c
   elems  = Multiple [Val1  . vVal $ x  | x <- getCollectionElems xREFmap c]
   belems = Multiple [bval__ . vVal $ x | x <- getCollectionElems xREFmap c]
   varpath_ = "__collection" : varpath
   
   theCol = case nub elemsTypes of
     ["int"]     ->  [(varpath_, DaikonType_ (Array_ Int_), "Collection int", elems)]
     ["Number"]  ->  [(varpath_, DaikonType_ (Array_ Double_), "Collection Number", elems)]
     ["Boolean"] ->  [(varpath_, DaikonType_ (Array_ Bool_), "Collection Boolean", belems)]
     ["String"]  ->  [(varpath_, DaikonType_ (Array_ String_), "Collection String", elems)]
     _           ->  [] 

convertDictionary_  xREFmap varpath d
   =
   theKeys    ++ [mkArrayElemsTypes varpath keysTypes]
   ++ theVals ++ [mkArrayElemsTypes varpath valsTypes]
   where
   (keys_,vals_) =  unzip . getDictionaryElems xREFmap $ d
   keysTypes = getDictionaryKeysTypes xREFmap d
   valsTypes = getDictionaryValsTypes xREFmap d 
   keys  = Multiple [Val1  . vVal $ x  | x <- keys_]
   bkeys = Multiple [bval__ . vVal $ x | x <- keys_]
   vals  = Multiple [Val1  . vVal $ x  | x <- vals_]
   bvals = Multiple [bval__ . vVal $ x | x <- vals_]
   
   varpath1 = "__keys" : varpath
   varpath2 = "__dictvals" : varpath
   
   theKeys = case nub keysTypes of
     ["int"]     ->  [(varpath1, DaikonType_ (Array_ Int_), "DictionaryKey int", keys)]
     ["Number"]  ->  [(varpath1, DaikonType_ (Array_ Double_), "DictionaryKey Number", keys)]
     ["Boolean"] ->  [(varpath1, DaikonType_ (Array_ Bool_), "DictionaryKey Boolean", bkeys)]
     ["String"]  ->  [(varpath1, DaikonType_ (Array_ String_), "DictionaryKey String", keys)]
     _           ->  []   

   theVals = case nub valsTypes of
     ["int"]     ->  [(varpath2, DaikonType_ (Array_ Int_), "DictionaryVal int", vals)]
     ["Number"]  ->  [(varpath2, DaikonType_ (Array_ Double_), "DictionaryVal Number", vals)]
     ["Boolean"] ->  [(varpath2, DaikonType_ (Array_ Bool_), "DictionaryVal Boolean", bvals)]
     ["String"]  ->  [(varpath2, DaikonType_ (Array_ String_), "DictionaryVal String", vals)]
     _           ->  []      


      
convertField xREFmap varpath (FieldValTy_ fname val ty)
    = 
    convertVal_ xREFmap (fname:varpath) (SingleVal_ {vVal=val, vTy=ty})
   
convertField xREFmap varpath (FieldXref_  fname id) 
    = 
    case find ((== id) . fst) xREFmap of
       Nothing    -> []
       Just (_,o) ->  [ mkPointerField varpath2 id,
                        mkTheTypeVirtualVar varpath2 (getValType o)]
                      ++ mkIsNullVirtualVar varpath False
                      ++ mkIsUndefinedVirtualVar varpath False
    where
    varpath2 = fname : varpath    
    
convertField xREFmap varpath (FieldObj_  fname obj) 
    = 
    convertVal_ xREFmap (fname:varpath) obj
    
--
-- For converting the argument of a high event to Daikon. The arguments
-- are assumed to be of simple type. If an argument is an object, 
-- it will be not serialized to Daikon.
--
convertArg argName val@(SingleVal_ _ _) = convertVal_ [] [argName] val
convertArg argName (Obj_ { ocname = cname , ofields = _ })
    =
    convertArg argName (SingleVal_ {vVal="??", vTy=cname}) 


---  ==========================================
---  Example
---

mkStructuredLog rawlog 
   = 
   uncurry (topRunCLparser parseEventLog) (dic1,log2) 
   where
   log2 = decompressTimeStamp log1
   (dic1,log1) = strCompress rawlog 

exDLog0   = putStr (showAsDaikonLog exLog0_)
exLog0_   = mkStructuredLog exLog0__   
exLog0__  = concat . intersperse "\n" 
            $
            [exEventFieldX,exEventFieldX, exEventCalc, exEventCalc]   
            
exEventCalc = concat . intersperse "\n" $
        ["%<S -120:1312489705920 \"E\"",
         -- the event object
         "%<S \"O:eu.fittest.actionscript.automation::RecordEvent\"",
         "%<P",
         "%<{ I=0:ID }%>",
         "%<{ targetID=\"Calculate\":String }%>",
         "%<{ type=\"click\":String }%>",
         "%<{ args=> }%>",
         "%>",
         "%<S \"O:Array\"",
         "%<P",
         "%<{ I=1:ID }%>",
         "%>",
         "%>",
         "%>",
         -- the app state object 
         "%<S \"O:mx.controls::TextInput\"",
         "%<P",
         "%<{ I=0:ID }%>",
         "%<{ id=\"r\":String }%>",
         "%<{ text=\"1\":String }%>",
         "%>",
         "%>",
         -- end of the top E-section
         "%>"
        ] 

exEventFieldX = concat . intersperse "\n" $
        ["%<S -120:1312489705930 \"E\"",
         -- the event object
         "%<S \"O:eu.fittest.actionscript.automation::RecordEvent\"",
         "%<P",
         "%<{ I=0:ID }%>",
         "%<{ targetID=\"FieldX\":String }%>",
         "%<{ type=\"type\":String }%>",
         "%<{ args=> }%>",
         "%>",
         "%<S \"O:Array\"",
         "%<P",
         "%<{ I=1:ID }%>",
         "%<{ elem=\"10\":String }%>",
         "%>",
         "%>",
         "%>",
         -- the app state object 
         "%<S \"O:mx.controls::TextInput\"",
         "%<P",
         "%<{ I=0:ID }%>",
         "%<{ id=\"r\":String }%>",
         "%<{ text=\"\":String }%>",
         "%>",
         "%>",
         -- end of the top E-section
         "%>"
        ]        
        
exDLog1   = putStr (showAsDaikonLog exLog1_)
exLog1_   = mkStructuredLog exLog1__   
exLog1__  = concat . intersperse "\n" 
            $
            [exEventAWithArrayState,exEventAWithArrayState,exEventAWithArrayState] 
            
exEventAWithArrayState = concat . intersperse "\n" $
        ["%<S -120:1312489705950 \"E\"",
         -- the event object
         "%<S \"O:eu.fittest.actionscript.automation::RecordEvent\"",
         "%<P",
         "%<{ I=0:ID }%>",
         "%<{ targetID=\"MagicButton\":String }%>",
         "%<{ type=\"foo\":String }%>",
         "%<{ args=> }%>",
         "%>",
         "%<S \"O:Array\"",
         "%<P",
         "%<{ I=1:ID }%>",
         "%<{ elem=\"999\":String }%>",
         "%>",
         "%>",
         "%>",
         -- the app state object 
         "%<S \"O:Array\"",
         "%<P",
         "%<{ I=0:ID }%>",
         "%<{ elem=10:int }%>",
         "%<{ elem=3:int }%>",
         "%>",
         "%>",
         -- end of the top E-section
         "%>"
        ]        
