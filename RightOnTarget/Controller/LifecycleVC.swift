//  LiecycleVC.swift
//  Right on target
//  Created by Ilya Zablotski

import UIKit

class LiecycleVC: UIViewController {
    override func loadView() {
        /// loadView выполняется 1-ым в ЖЦ.
        /// Вызывается единыжды за все время ЖЦ.
        /// loadView прекрасно подходит для того,
        /// чтобы создать новые графические элементы с помощью программного кода
        super.loadView()
        /// super прописывать обязательно
        /// тк в родительском loadView множество действий скрытых от dev
        print("Executed loadView")
    }
    
    override func viewDidLoad() {
        /// viewDidLoad вызывается сразу после загрузки отображений (выполнения метода loadView).
        /// Вызывается единыжды за все время ЖЦ.
        /// Подходит для внесения финальных правок перед выводом сцены на экран
        super.viewDidLoad()
        // Создаем экземпляр сущности "Игра"
        print("Executed viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /// viewWillAppear вызывается перед тем, как графические элементы сцены
        /// будут добавлены в иерархию графических элементов.
        /// Вызывается каждый раз, когда сцена добавляется в иерархию.
        super.viewWillAppear(animated)
        print("Executed viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /// viewDidAppear вызывается после того, как графические элементы сцены добавлены в иерархию view
        /// Подходит для описания действий, которые должны быть выполнены после отображения элементов на экране
        /// Например: запустить анимацию на сцене или синхронизировать данные с сервером
        super.viewDidAppear(animated)
        print("Executed viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /// viewWillDisappear вызывается до удаления элементов сцены из иерархии view
        super.viewWillDisappear(animated)
        print("Executed viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        /// viewDidDisappear вызывается после удаления элементов сцены из иерархии view
        super.viewDidDisappear(animated)
        print("Executed viewDidDisappear")
    }
}

