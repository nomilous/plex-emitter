// Generated by CoffeeScript 1.4.0
var Thing;

module.exports = Thing = (function() {

  function Thing(result) {
    this.result = result;
  }

  Thing.prototype["do"] = function(duration, callback) {
    var _this = this;
    return setTimeout(function() {
      return callback(null, _this.result);
    }, duration);
  };

  Thing.doo = function(instance, duration, callback) {
    console.log('on', instance);
    return setTimeout(function() {
      return callback(null, instance.result);
    }, duration);
  };

  Thing.fails = function(instance, duration, callback) {
    return setTimeout(function() {
      return callback(new Error(instance.result + ' failed'));
    }, duration);
  };

  return Thing;

})();
