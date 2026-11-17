//
//  SceneDelegate.swift
//  chchaat
//
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .dark
        self.window = window

        showMainFlow(in: window)

        window.makeKeyAndVisible()
    }

    private func showMainFlow(in window: UIWindow, animated: Bool = false) {
        let homeVC = FirstVC()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), tag: 0)
        homeNav.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let dashboardVC = SecondVC()
        let dashboardNav = UINavigationController(rootViewController: dashboardVC)
        dashboardNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "square.grid.2x2.fill"), tag: 1)
        dashboardNav.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let moreVC = ThirdVC()
        let moreNav = UINavigationController(rootViewController: moreVC)
        moreNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "flame.fill"), tag: 2)
        moreNav.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let moreVC2 = MoreViewController()
        let moreVC2Nav = UINavigationController(rootViewController: moreVC2)
        moreVC2Nav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "ellipsis.circle.fill"), tag: 2)
        moreVC2Nav.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNav, dashboardNav, moreNav, moreVC2Nav]

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.surface
        appearance.stackedLayoutAppearance.normal.iconColor = AppColors.textSecondary
        appearance.stackedLayoutAppearance.selected.iconColor = AppColors.tint

        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance

        if animated {
            UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
                window.rootViewController = tabBarController
            })
        } else {
            window.rootViewController = tabBarController
        }
    }
}
