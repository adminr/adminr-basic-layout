var mod = angular.module('adminr-test',['adminr-basic-layout']);

mod.config(function(AdminrBasicLayoutProvider){
    AdminrBasicLayoutProvider.setHomePage('Home','home.html')
    AdminrBasicLayoutProvider.addPage('page1','Page 1',{templateUrl:'page1.html'})
        .addPage('subpage1','Sub Page 1',{templateUrl:'sub-page1.html'})
    AdminrBasicLayoutProvider.addPage('google','External link',{url:'http://google.com',external:true})
})

mod.controller('TestCtrl',function($scope,AdminrBasicLayout){
    $scope.homePage = AdminrBasicLayout.homePage
})