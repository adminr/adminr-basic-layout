mod = angular.module('adminr-basic-layout',['ui.router'])


# https://github.com/angular-ui/ui-router/issues/679
mod.run(['$state', angular.noop]);

mod.config(['$stateProvider', '$urlRouterProvider',($stateProvider, $urlRouterProvider)->
  $urlRouterProvider.otherwise('/')
])

mod.run(['$rootScope','$window','$state','AdminrBasicLayout',($rootScope,$window,$state,AdminrBasicLayout)->
  $rootScope.$state = $state
  $rootScope.$homePage = AdminrBasicLayout.homePage
  $rootScope.$on('$stateChangeStart',(event, toState, toParams, fromState, fromParams)->
    if toState.external
      event.preventDefault()
      $window.open(toState.url, '_blank')
    $rootScope.$page = toState.page
  )
])

mod.provider('AdminrBasicLayout',['$stateProvider',($stateProvider)->

  class Page
    icon: 'angle-right'
    constructor:(@stateName,@name,@options = {})->
      @parent = null
      @children = []
      if @stateName
        @options.url = @options.url or ('/' + @stateName)
        if not @options.templateUrl and @options.template
          @options.template = '<div ui-view></div>'


    createState:()->
      options = angular.copy(@options)
      options.page = @
      @state = $stateProvider.state(@getStateName(),options)

    getStateName:()->
      return @stateName

    addPage:(state,name,options)->
      page = new Page(state,name,options)
      @children.push(page)
      page.parent = @
      page.createState()
      return page

    setIcon:(icon)->
      @icon = icon
      return @
    getIcon:()->
      return @icon

    getParentPages:(array = [])->
      if @parent?.name
        array.unshift(@parent)
        @parent.getParentPages(array)
      return array

  class AdminrBacisLayout

    homePage: new Page()

    setHomePage: (name,templateUrl)->
      @homePage = new Page('home',name,{url:'/',templateUrl:templateUrl})
      @homePage.setIcon('dashboard')
      @homePage.createState()
      return @homePage

    addPage: (state,name,options)->
      if not @homePage
        throw new Error('AdminrBasicLayout set home page before adding another pages')
      return @homePage.addPage(state,name,options)

    $get:()->
      return @

  return new AdminrBacisLayout()
])
