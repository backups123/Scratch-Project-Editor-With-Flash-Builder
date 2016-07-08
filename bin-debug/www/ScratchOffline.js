
// Fake the Scratch.FlashApp.ASObj object for the offline version of the editor.
// Methods are generally wrappers for JS/AS bridge calls.

var Scratch = Scratch || {};
Scratch.FlashApp = Scratch.FlashApp || {};

Scratch.FlashApp.ASobj = new (function() {
    var lib = this;

    window.console = window.console || {};
    console.log = function() {
        var text = 'Console.log: ' + Array.prototype.join.call(arguments, ' ');
        StageWebViewBridge.call('log', null, text);
    };

    function HIDDevice(openedHandle) {
        var device = this;

        // Public methods on HID devices

        device.dispose = function() {
            StageWebViewBridge.call('hid.dispose', null, openedHandle);
        };

        device.read = function(size, callback) {
            function readCallback(base64Data) {
                var data = b64_to_ab(base64Data);
                callback(data);
            }
            StageWebViewBridge.call('hid.read_raw', readCallback, openedHandle, size);
        };

        device.write = function(data, callback) {
            var str = ab_to_b64(data);
            StageWebViewBridge.call('hid.write_raw', callback, openedHandle, str);
        };

        device.set_nonblocking = function(flag) {
            StageWebViewBridge.call('hid.set_nonblocking', null, openedHandle, flag);
        };

        device.get_feature_report = function(callback, size) {
            function readCallback(base64Data) {
                var data = b64_to_ab(base64Data);
                callback(data);
            }
            StageWebViewBridge.call('hid.get_feature_report_raw', readCallback, openedHandle, size);
        };

        device.send_feature_report = function(data, callback) {
            var str = ab_to_b64(data);
            StageWebViewBridge.call('hid.send_feature_report_raw', callback, openedHandle, str);
        };

        device.close = function() {
            StageWebViewBridge.call('hid.close', null, openedHandle);
        };
    }

    function SerialDevice(openedHandle) {
        var device = this;

        var errorHandlers = {};
        var receiveHandlers = {};

        function globalErrorHandler(handle, error) {
            var handler = errorHandlers[handle];
            if (handler) {
                handler(error);
            }
        }

        function globalReceiveHandler(handle, base64Data) {
            var handler = receiveHandlers[handle];
            if (handler) {
                var data = b64_to_ab(base64Data);
                handler(data);
            }
        }

        // These must be registered globally so that they can be called from AS
        Scratch = Scratch || {};
        Scratch.Offline = Scratch.Offline || {};
        Scratch.Offline.serialErrorHandler = globalErrorHandler;
        Scratch.Offline.serialReceiveHandler = globalReceiveHandler;

        // Public methods on a serial device

        device.dispose = function() {
            StageWebViewBridge.call('serial.dispose', null, openedHandle);
            delete receiveHandlers[openedHandle];
            delete errorHandlers[openedHandle];
        };

        device.send = function(data) {
            var str = ab_to_b64(data);
            StageWebViewBridge.call('serial.send', null, openedHandle, str);
        };

        device.set_receive_handler = function(handlerFunction) {
            receiveHandlers[openedHandle] = handlerFunction;
            StageWebViewBridge.call('serial.enable_receive_handler', null, openedHandle, !!handlerFunction);
        };

        device.set_error_handler = function(handlerFunction) {
            errorHandlers[openedHandle] = handlerFunction;
            StageWebViewBridge.call('serial.enable_error_handler', null, openedHandle, !!handlerFunction);
        };

        device.close = function() {
            StageWebViewBridge.call('serial.close', null, openedHandle);
        };

        device.is_open = function(callback) {
            StageWebViewBridge.call('serial.is_open', callback);
        };
    }

    var plugin = new (function() {
        var p = this;
        var version;

        StageWebViewBridge.call('plugin.version', function(v) { p.version = v; });

        p.serial_list = function(callback) {
            StageWebViewBridge.call('plugin.serial_list', callback);
        };

        p.serial_open = function(path, options, callback) {
            function onOpen(handle) {
                var dev;
                if (handle) dev = new SerialDevice(handle);
                callback(dev);
            }
            StageWebViewBridge.call('plugin.serial_open', onOpen, path, options);
        };

        p.hid_list = function(callback) {
            StageWebViewBridge.call('plugin.hid_list', callback);
        };

        p.hid_open = function(path, callback) {
            function onOpen(handle) {
                var dev;
                if (handle) dev = new HIDDevice(handle);
                callback(dev);
            }
            StageWebViewBridge.call('plugin.hid_open', onOpen, path);
        };

        p.version = function() {
            if (version) {
                return version;
            }
            alert('Version not ready');
        };
    })();

    // If this is true (and not undefined) then no plugin is necessary.
    lib.isOffline = function() {
        return true;
    };

    lib.getPlugin = function() {
        return plugin;
    };

    lib.ASloadExtension = function(extObj) {
        StageWebViewBridge.call('ASloadExtension', null, extObj);
    };

    lib.ASextensionReporterDone = function(ext_name, job_id, retval) {
        StageWebViewBridge.call('ASextensionReporterDone', null, ext_name, job_id, retval);
    };

    lib.ASextensionCallDone = function(ext_name, job_id) {
        StageWebViewBridge.call('ASextensionCallDone', null, ext_name, job_id);
    };

})();
