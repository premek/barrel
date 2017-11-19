
var Module;

if (typeof Module === 'undefined') Module = eval('(function() { try { return Module || {} } catch(e) { return {} } })()');

if (!Module.expectedDataFileDownloads) {
  Module.expectedDataFileDownloads = 0;
  Module.finishedDataFileDownloads = 0;
}
Module.expectedDataFileDownloads++;
(function() {
 var loadPackage = function(metadata) {

    var PACKAGE_PATH;
    if (typeof window === 'object') {
      PACKAGE_PATH = window['encodeURIComponent'](window.location.pathname.toString().substring(0, window.location.pathname.toString().lastIndexOf('/')) + '/');
    } else if (typeof location !== 'undefined') {
      // worker
      PACKAGE_PATH = encodeURIComponent(location.pathname.toString().substring(0, location.pathname.toString().lastIndexOf('/')) + '/');
    } else {
      throw 'using preloaded data can only be done on a web page or in a web worker';
    }
    var PACKAGE_NAME = 'game.data';
    var REMOTE_PACKAGE_BASE = 'game.data';
    if (typeof Module['locateFilePackage'] === 'function' && !Module['locateFile']) {
      Module['locateFile'] = Module['locateFilePackage'];
      Module.printErr('warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)');
    }
    var REMOTE_PACKAGE_NAME = typeof Module['locateFile'] === 'function' ?
                              Module['locateFile'](REMOTE_PACKAGE_BASE) :
                              ((Module['filePackagePrefixURL'] || '') + REMOTE_PACKAGE_BASE);
  
    var REMOTE_PACKAGE_SIZE = metadata.remote_package_size;
    var PACKAGE_UUID = metadata.package_uuid;
  
    function fetchRemotePackage(packageName, packageSize, callback, errback) {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', packageName, true);
      xhr.responseType = 'arraybuffer';
      xhr.onprogress = function(event) {
        var url = packageName;
        var size = packageSize;
        if (event.total) size = event.total;
        if (event.loaded) {
          if (!xhr.addedTotal) {
            xhr.addedTotal = true;
            if (!Module.dataFileDownloads) Module.dataFileDownloads = {};
            Module.dataFileDownloads[url] = {
              loaded: event.loaded,
              total: size
            };
          } else {
            Module.dataFileDownloads[url].loaded = event.loaded;
          }
          var total = 0;
          var loaded = 0;
          var num = 0;
          for (var download in Module.dataFileDownloads) {
          var data = Module.dataFileDownloads[download];
            total += data.total;
            loaded += data.loaded;
            num++;
          }
          total = Math.ceil(total * Module.expectedDataFileDownloads/num);
          if (Module['setStatus']) Module['setStatus']('Downloading data... (' + loaded + '/' + total + ')');
        } else if (!Module.dataFileDownloads) {
          if (Module['setStatus']) Module['setStatus']('Downloading data...');
        }
      };
      xhr.onload = function(event) {
        var packageData = xhr.response;
        callback(packageData);
      };
      xhr.send(null);
    };

    function handleError(error) {
      console.error('package error:', error);
    };
  
      var fetched = null, fetchedCallback = null;
      fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE, function(data) {
        if (fetchedCallback) {
          fetchedCallback(data);
          fetchedCallback = null;
        } else {
          fetched = data;
        }
      }, handleError);
    
  function runWithFS() {

    function assert(check, msg) {
      if (!check) throw msg + new Error().stack;
    }
Module['FS_createPath']('/', 'gamestate', true, true);
Module['FS_createPath']('/', 'lib', true, true);
Module['FS_createPath']('/lib', 'hump', true, true);
Module['FS_createPath']('/', 'music', true, true);

    function DataRequest(start, end, crunched, audio) {
      this.start = start;
      this.end = end;
      this.crunched = crunched;
      this.audio = audio;
    }
    DataRequest.prototype = {
      requests: {},
      open: function(mode, name) {
        this.name = name;
        this.requests[name] = this;
        Module['addRunDependency']('fp ' + this.name);
      },
      send: function() {},
      onload: function() {
        var byteArray = this.byteArray.subarray(this.start, this.end);

          this.finish(byteArray);

      },
      finish: function(byteArray) {
        var that = this;

        Module['FS_createDataFile'](this.name, null, byteArray, true, true, true); // canOwn this data in the filesystem, it is a slide into the heap that will never change
        Module['removeRunDependency']('fp ' + that.name);

        this.requests[this.name] = null;
      },
    };

        var files = metadata.files;
        for (i = 0; i < files.length; ++i) {
          new DataRequest(files[i].start, files[i].end, files[i].crunched, files[i].audio).open('GET', files[i].filename);
        }

  
    function processPackageData(arrayBuffer) {
      Module.finishedDataFileDownloads++;
      assert(arrayBuffer, 'Loading data file failed.');
      assert(arrayBuffer instanceof ArrayBuffer, 'bad input to processPackageData');
      var byteArray = new Uint8Array(arrayBuffer);
      var curr;
      
        // copy the entire loaded file into a spot in the heap. Files will refer to slices in that. They cannot be freed though
        // (we may be allocating before malloc is ready, during startup).
        if (Module['SPLIT_MEMORY']) Module.printErr('warning: you should run the file packager with --no-heap-copy when SPLIT_MEMORY is used, otherwise copying into the heap may fail due to the splitting');
        var ptr = Module['getMemory'](byteArray.length);
        Module['HEAPU8'].set(byteArray, ptr);
        DataRequest.prototype.byteArray = Module['HEAPU8'].subarray(ptr, ptr+byteArray.length);
  
          var files = metadata.files;
          for (i = 0; i < files.length; ++i) {
            DataRequest.prototype.requests[files[i].filename].onload();
          }
              Module['removeRunDependency']('datafile_game.data');

    };
    Module['addRunDependency']('datafile_game.data');
  
    if (!Module.preloadResults) Module.preloadResults = {};
  
      Module.preloadResults[PACKAGE_NAME] = {fromCache: false};
      if (fetched) {
        processPackageData(fetched);
        fetched = null;
      } else {
        fetchedCallback = processPackageData;
      }
    
  }
  if (Module['calledRun']) {
    runWithFS();
  } else {
    if (!Module['preRun']) Module['preRun'] = [];
    Module["preRun"].push(runWithFS); // FS is not initialized yet, wait for it
  }

 }
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 54304, "filename": "/ShadowsIntoLight.ttf"}, {"audio": 0, "start": 54304, "crunched": 0, "end": 56150, "filename": "/assets.lua"}, {"audio": 0, "start": 56150, "crunched": 0, "end": 57588, "filename": "/main.lua"}, {"audio": 0, "start": 57588, "crunched": 0, "end": 57913, "filename": "/conf.lua.bak"}, {"audio": 0, "start": 57913, "crunched": 0, "end": 58241, "filename": "/conf.lua"}, {"audio": 0, "start": 58241, "crunched": 0, "end": 63600, "filename": "/gamestate/_level.lua"}, {"audio": 0, "start": 63600, "crunched": 0, "end": 64004, "filename": "/gamestate/ending.lua"}, {"audio": 0, "start": 64004, "crunched": 0, "end": 64671, "filename": "/gamestate/mainmenu.lua"}, {"audio": 0, "start": 64671, "crunched": 0, "end": 64859, "filename": "/gamestate/part1.lua"}, {"audio": 0, "start": 64859, "crunched": 0, "end": 65014, "filename": "/gamestate/part1end.lua"}, {"audio": 0, "start": 65014, "crunched": 0, "end": 65162, "filename": "/gamestate/part1title.lua"}, {"audio": 0, "start": 65162, "crunched": 0, "end": 65360, "filename": "/gamestate/part2.lua"}, {"audio": 0, "start": 65360, "crunched": 0, "end": 65507, "filename": "/gamestate/part2end.lua"}, {"audio": 0, "start": 65507, "crunched": 0, "end": 65655, "filename": "/gamestate/part2title.lua"}, {"audio": 0, "start": 65655, "crunched": 0, "end": 65832, "filename": "/gamestate/part3.lua"}, {"audio": 0, "start": 65832, "crunched": 0, "end": 65986, "filename": "/gamestate/part3end.lua"}, {"audio": 0, "start": 65986, "crunched": 0, "end": 66134, "filename": "/gamestate/part3title.lua"}, {"audio": 0, "start": 66134, "crunched": 0, "end": 66281, "filename": "/gamestate/part4.lua"}, {"audio": 0, "start": 66281, "crunched": 0, "end": 66426, "filename": "/gamestate/part4end.lua"}, {"audio": 0, "start": 66426, "crunched": 0, "end": 66574, "filename": "/gamestate/part4title.lua"}, {"audio": 0, "start": 66574, "crunched": 0, "end": 66816, "filename": "/gamestate/part5.lua"}, {"audio": 0, "start": 66816, "crunched": 0, "end": 66981, "filename": "/gamestate/part5end.lua"}, {"audio": 0, "start": 66981, "crunched": 0, "end": 67129, "filename": "/gamestate/part5title.lua"}, {"audio": 0, "start": 67129, "crunched": 0, "end": 68544, "filename": "/lib/require.lua"}, {"audio": 0, "start": 68544, "crunched": 0, "end": 72077, "filename": "/lib/hump/gamestate.lua"}, {"audio": 0, "start": 72077, "crunched": 0, "end": 74609, "filename": "/lib/hump/signal.lua"}, {"audio": 0, "start": 74609, "crunched": 0, "end": 81142, "filename": "/lib/hump/timer.lua"}, {"audio": 1, "start": 81142, "crunched": 0, "end": 2051417, "filename": "/music/borealism x [ocean jams] -  kill-it.mp3"}, {"audio": 1, "start": 2051417, "crunched": 0, "end": 4414557, "filename": "/music/borealism-glider.mp3"}, {"audio": 1, "start": 4414557, "crunched": 0, "end": 4453151, "filename": "/music/part1intro.mp3"}, {"audio": 1, "start": 4453151, "crunched": 0, "end": 5995623, "filename": "/music/premek-stick_guitar.mp3"}, {"audio": 1, "start": 5995623, "crunched": 0, "end": 8632251, "filename": "/music/xavfalcon-late-nights.mp3"}], "remote_package_size": 8632251, "package_uuid": "6732ce8c-bf27-44b7-879a-f3ea6881dfb8"});

})();
