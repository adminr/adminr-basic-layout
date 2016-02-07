(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var mod;

mod = angular.module('adminr-basic-layout', ['ui.router']);

mod.run(['$state', angular.noop]);

mod.config([
  '$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
    return $urlRouterProvider.otherwise('/');
  }
]);

mod.run([
  '$rootScope', '$window', '$state', function($rootScope, $window, $state) {
    $rootScope.$state = $state;
    return $rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromState, fromParams) {
      if (toState.external) {
        event.preventDefault();
        $window.open(toState.url, '_blank');
      }
      return $rootScope.$page = toState.page;
    });
  }
]);

mod.provider('AdminrBasicLayout', [
  '$stateProvider', function($stateProvider) {
    var AdminrBacisLayout, Page;
    Page = (function() {
      Page.prototype.icon = 'angle-right';

      function Page(stateName, name1, options1) {
        this.stateName = stateName;
        this.name = name1;
        this.options = options1 != null ? options1 : {};
        this.parent = null;
        this.children = [];
        if (this.stateName) {
          this.options.url = this.options.url || ('/' + this.stateName);
          if (!this.options.templateUrl && this.options.template) {
            this.options.template = '<div ui-view></div>';
          }
        }
      }

      Page.prototype.createState = function() {
        var options;
        options = angular.copy(this.options);
        options.page = this;
        return this.state = $stateProvider.state(this.getStateName(), options);
      };

      Page.prototype.getStateName = function() {
        return this.stateName;
      };

      Page.prototype.addPage = function(state, name, url, templateUrl) {
        var page;
        page = new Page(state, name, url, templateUrl);
        this.children.push(page);
        page.parent = this;
        page.createState();
        return page;
      };

      Page.prototype.setIcon = function(icon) {
        this.icon = icon;
        return this;
      };

      Page.prototype.getIcon = function() {
        return this.icon;
      };

      Page.prototype.getParentPages = function(array) {
        var ref;
        if (array == null) {
          array = [];
        }
        if ((ref = this.parent) != null ? ref.name : void 0) {
          array.push(this.parent);
          this.parent.getParentPages(array);
        }
        return array;
      };

      return Page;

    })();
    AdminrBacisLayout = (function() {
      function AdminrBacisLayout() {}

      AdminrBacisLayout.prototype.homePage = new Page();

      AdminrBacisLayout.prototype.setHomePage = function(name, templateUrl) {
        return this.addPage('home', name, {
          url: '/',
          templateUrl: templateUrl
        }).setIcon('dashboard');
      };

      AdminrBacisLayout.prototype.addPage = function(state, name, url, templateUrl) {
        if (!this.homePage) {
          throw new Error('AdminrBasicLayout set home page before adding another pages');
        }
        return this.homePage.addPage(state, name, url, templateUrl);
      };

      AdminrBacisLayout.prototype.$get = function() {
        return this;
      };

      return AdminrBacisLayout;

    })();
    return new AdminrBacisLayout();
  }
]);


},{}]},{},[1]);
