mod = angular.module('adminr-basic-layout',['ui.router'])


mod.run(['$state', angular.noop]);


mod.config(['$stateProvider', '$urlRouterProvider',($stateProvider, $urlRouterProvider)->
  $urlRouterProvider.otherwise('/')
])

mod.run(['$rootScope','$window','$state',($rootScope,$window,$state)->
  $rootScope.$state = $state
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

    addPage:(state,name,url,templateUrl)->
      page = new Page(state,name,url,templateUrl)
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
        array.push(@parent)
        @parent.getParentPages(array)
      return array

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
