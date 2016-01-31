mod = angular.module('adminr-basic-layout',['ui.router'])


mod.run(['$state', angular.noop]);


mod.config(['$stateProvider', '$urlRouterProvider',($stateProvider, $urlRouterProvider)->
  $urlRouterProvider.otherwise('/')
])

mod.run(['$rootScope','$window',($rootScope,$window)->
  $rootScope.$on('$stateChangeStart',(event, toState, toParams, fromState, fromParams)->
    if toState.external
      event.preventDefault()
      $window.open(toState.url, '_blank')
  )
])

mod.provider('AdminrBasicLayout',['$stateProvider',($stateProvider)->

  class Page
    icon: 'angle-right'
    constructor:(@stateName,@name,@options = {})->
      @children = []
      if @stateName
        @options.url = @options.url or ('/' + @stateName)
        if not @options.templateUrl and @options.template
          @options.template = '<div ui-view></div>'

        @state = $stateProvider.state(@stateName,@options)

    addPage:(state,name,url,templateUrl)->
      page = new Page(state,name,url,templateUrl)
      @children.push(page)
      return page

    setIcon:(icon)->
      @icon = icon
      return @
    getIcon:()->
      return @icon

  class AdminrBacisLayout

    homePage: new Page()

    setHomePage: (name,templateUrl)->
      return @addPage('home',name,{url:'/',templateUrl:templateUrl}).setIcon('dashboard')

    addPage: (state,name,url,templateUrl)->
      if not @homePage
        throw new Error('AdminrBasicLayout set home page before adding another pages')
      return @homePage.addPage(state,name,url,templateUrl)

    $get:()->
      return @

  return new AdminrBacisLayout()
])
