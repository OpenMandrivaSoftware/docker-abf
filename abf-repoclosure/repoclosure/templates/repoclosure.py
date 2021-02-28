#!/usr/bin/env python




##################################################
## DEPENDENCIES
import sys
import os
import os.path
try:
    import builtins as builtin
except ImportError:
    import __builtin__ as builtin
from os.path import getmtime, exists
import time
import types
from Cheetah.Version import MinCompatibleVersion as RequiredCheetahVersion
from Cheetah.Version import MinCompatibleVersionTuple as RequiredCheetahVersionTuple
from Cheetah.Template import Template
from Cheetah.DummyTransaction import *
from Cheetah.NameMapper import NotFound, valueForName, valueFromSearchList, valueFromFrameOrSearchList
from Cheetah.CacheRegion import CacheRegion
import Cheetah.Filters as Filters
import Cheetah.ErrorCatchers as ErrorCatchers
from Cheetah.compat import unicode
from .layout import layout

##################################################
## MODULE CONSTANTS
VFFSL=valueFromFrameOrSearchList
VFSL=valueFromSearchList
VFN=valueForName
currentTime=time.time
__CHEETAH_version__ = '3.2.6'
__CHEETAH_versionTuple__ = (3, 2, 6, 'final', 0)
__CHEETAH_genTime__ = 1604776366.3041327
__CHEETAH_genTimestamp__ = 'Sat Nov  7 19:12:46 2020'
__CHEETAH_src__ = 'repoclosure.tmpl'
__CHEETAH_srcLastModified__ = 'Sat Nov  7 19:11:55 2020'
__CHEETAH_docstring__ = 'Autogenerated by Cheetah: The Python-Powered Template Engine'

if __CHEETAH_versionTuple__ < RequiredCheetahVersionTuple:
    raise AssertionError(
      'This template was compiled with Cheetah version'
      ' %s. Templates compiled before version %s must be recompiled.'%(
         __CHEETAH_version__, RequiredCheetahVersion))

##################################################
## CLASSES

class repoclosure(layout):

    ##################################################
    ## CHEETAH GENERATED METHODS


    def __init__(self, *args, **KWs):

        super(repoclosure, self).__init__(*args, **KWs)
        if not self._CHEETAH__instanceInitialized:
            cheetahKWArgs = {}
            allowedKWs = 'searchList namespaces filter filtersLib errorCatcher'.split()
            for k,v in KWs.items():
                if k in allowedKWs: cheetahKWArgs[k] = v
            self._initCheetahInstance(**cheetahKWArgs)
        

    def mainContent(self, **KWS):



        ## CHEETAH: generated from #def mainContent() at line 3, col 1.
        trans = KWS.get("trans")
        if (not trans and not self._CHEETAH__isBuffering and not callable(self.transaction)):
            trans = self.transaction # is None unless self.awake() was called
        if not trans:
            trans = DummyTransaction()
            _dummyTrans = True
        else: _dummyTrans = False
        write = trans.response().write
        SL = self._CHEETAH__searchList
        _filter = self._CHEETAH__currentFilter
        
        ########################################
        ## START - generated method body
        
        write('''<div class="row">
  <div class="col">
''')
        if VFFSL(SL,"code",True) == -1: # generated from line 6, col 5
            write('''      <p>
        An exception occured, while executing repoclosure for this repository:
        <pre>''')
            _v = VFFSL(SL,"errors",True) # '$errors' on line 9, col 14
            if _v is not None: write(_filter(_v, rawExpr='$errors')) # from line 9, col 14.
            write('''</pre>
      </p>
''')
        else: # generated from line 11, col 5
            if VFFSL(SL,"code",True) == 0: # generated from line 12, col 7
                write('''        <p>
          Repoclosure ended with exit code 0.
        </p>
''')
            else: # generated from line 16, col 7
                write('''        <p>
          Repoclosure ended with exit code ''')
                _v = VFFSL(SL,"code",True) # '${code}' on line 18, col 44
                if _v is not None: write(_filter(_v, rawExpr='${code}')) # from line 18, col 44.
                write(''', stderr:
          <pre>''')
                _v = VFFSL(SL,"errors",True) # '$errors' on line 19, col 16
                if _v is not None: write(_filter(_v, rawExpr='$errors')) # from line 19, col 16.
                write('''</pre>
        </p>
''')
            write('''      <p>
        ''')
            _v = VFFSL(SL,"count",True) # '$count' on line 23, col 9
            if _v is not None: write(_filter(_v, rawExpr='$count')) # from line 23, col 9.
            write(''' out of ''')
            _v = VFFSL(SL,"total_count",True) # '${total_count}' on line 23, col 23
            if _v is not None: write(_filter(_v, rawExpr='${total_count}')) # from line 23, col 23.
            write('''(''')
            _v = VFFSL(SL,"percent",True) # '${percent}' on line 23, col 38
            if _v is not None: write(_filter(_v, rawExpr='${percent}')) # from line 23, col 38.
            write('''%) packages have unresolved dependencies.
      </p>
      <table class="table table-hover table-sm table-bordered">
        <thead class="thead-light">
          <th scope="col">#</th>
          <th scope="col">Package</th>
          <th scope="col">SRPM</th>
          <th scope="col">Uresolved dependencies</th>
        </thead>
        <tbody>
''')
            cnt = 1
            for nevra, src, unresolved in VFFSL(SL,"bad_packages",True): # generated from line 34, col 11
                write('''            <tr>
              <th scope="row">''')
                _v = VFFSL(SL,"cnt",True) # '$cnt' on line 36, col 31
                if _v is not None: write(_filter(_v, rawExpr='$cnt')) # from line 36, col 31.
                write('''</th>
              <td>''')
                _v = VFFSL(SL,"nevra",True) # '$nevra' on line 37, col 19
                if _v is not None: write(_filter(_v, rawExpr='$nevra')) # from line 37, col 19.
                write('''</td>
              <td>''')
                _v = VFFSL(SL,"src",True) # '$src' on line 38, col 19
                if _v is not None: write(_filter(_v, rawExpr='$src')) # from line 38, col 19.
                write('''</td>
              <td>
                <pre>''')
                _v = VFFSL(SL,"unresolved",True) # '$unresolved' on line 40, col 22
                if _v is not None: write(_filter(_v, rawExpr='$unresolved')) # from line 40, col 22.
                write('''</pre>
              </td>
            </tr>
''')
                cnt = VFFSL(SL,"cnt",True) + 1
            write('''        </tbody>
      </table>
''')
        write('''  </div>
</div>
''')
        
        ########################################
        ## END - generated method body
        
        return _dummyTrans and trans.response().getvalue() or ""
        

    def links(self, **KWS):



        ## CHEETAH: generated from #def links at line 51, col 1.
        trans = KWS.get("trans")
        if (not trans and not self._CHEETAH__isBuffering and not callable(self.transaction)):
            trans = self.transaction # is None unless self.awake() was called
        if not trans:
            trans = DummyTransaction()
            _dummyTrans = True
        else: _dummyTrans = False
        write = trans.response().write
        SL = self._CHEETAH__searchList
        _filter = self._CHEETAH__currentFilter
        
        ########################################
        ## START - generated method body
        
        write('''<ul class="navbar-nav">
  <li class="nav-item">
    <a class="nav-link" href="index.html">Index</a>
  </li>
''')
        if VFFSL(SL,"code",True) != -1: # generated from line 56, col 3
            write('''    <li class="nav-item">
      <a class="nav-link" href="''')
            _v = VFFSL(SL,"compressed",True) # '$compressed' on line 58, col 33
            if _v is not None: write(_filter(_v, rawExpr='$compressed')) # from line 58, col 33.
            write('''">Compressed report</a>
    </li>
''')
        write('''</ul>
''')
        
        ########################################
        ## END - generated method body
        
        return _dummyTrans and trans.response().getvalue() or ""
        

    def writeBody(self, **KWS):



        ## CHEETAH: main method generated for this template
        trans = KWS.get("trans")
        if (not trans and not self._CHEETAH__isBuffering and not callable(self.transaction)):
            trans = self.transaction # is None unless self.awake() was called
        if not trans:
            trans = DummyTransaction()
            _dummyTrans = True
        else: _dummyTrans = False
        write = trans.response().write
        SL = self._CHEETAH__searchList
        _filter = self._CHEETAH__currentFilter
        
        ########################################
        ## START - generated method body
        
        
        ########################################
        ## END - generated method body
        
        return _dummyTrans and trans.response().getvalue() or ""
        
    ##################################################
    ## CHEETAH GENERATED ATTRIBUTES


    _CHEETAH__instanceInitialized = False

    _CHEETAH_version = __CHEETAH_version__

    _CHEETAH_versionTuple = __CHEETAH_versionTuple__

    _CHEETAH_genTime = __CHEETAH_genTime__

    _CHEETAH_genTimestamp = __CHEETAH_genTimestamp__

    _CHEETAH_src = __CHEETAH_src__

    _CHEETAH_srcLastModified = __CHEETAH_srcLastModified__

    _mainCheetahMethod_for_repoclosure = 'writeBody'

## END CLASS DEFINITION

if not hasattr(repoclosure, '_initCheetahAttributes'):
    templateAPIClass = getattr(repoclosure,
                               '_CHEETAH_templateClass',
                               Template)
    templateAPIClass._addCheetahPlumbingCodeToClass(repoclosure)


# CHEETAH was developed by Tavis Rudd and Mike Orr
# with code, advice and input from many other volunteers.
# For more information visit https://cheetahtemplate.org/

##################################################
## if run from command line:
if __name__ == '__main__':
    from Cheetah.TemplateCmdLineIface import CmdLineIface
    CmdLineIface(templateObj=repoclosure()).run()

