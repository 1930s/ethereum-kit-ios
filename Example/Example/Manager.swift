import Foundation
import RealmSwift
import RxSwift
import HSEthereumKit

class Manager {
    static let shared = Manager()

    private let keyWords = "mnemonic_words"

    let networkType: Network = .ropsten

    var walletKit: EthereumKit!

    init() {
        if let words = savedWords {
            initWalletKit(words: words)
        }
    }

    func login(words: [String]) {
        save(words: words)
        initWalletKit(words: words)
    }

    func logout() {
        do {
            try walletKit.clear()
        } catch {
            print("WalletKit Clear Error: \(error)")
        }

        clearWords()
        walletKit = nil
    }

    private func initWalletKit(words: [String]) {
        walletKit = EthereumKit(withWords: words, network: networkType)
    }

    private var savedWords: [String]? {
        if let wordsString = UserDefaults.standard.value(forKey: keyWords) as? String {
            return wordsString.split(separator: " ").map(String.init)
        }
        return nil
    }

    private func save(words: [String]) {
        UserDefaults.standard.set(words.joined(separator: " "), forKey: keyWords)
        UserDefaults.standard.synchronize()
    }

    private func clearWords() {
        UserDefaults.standard.removeObject(forKey: keyWords)
        UserDefaults.standard.synchronize()
    }

}

//extension Manager: BitcoinKitDelegate {
//
//    public func transactionsUpdated(walletKit: WalletKit, inserted: [TransactionInfo], updated: [TransactionInfo], deleted: [Int]) {
//        transactionsSubject.onNext(())
//    }
//
//    public func balanceUpdated(walletKit: WalletKit, balance: Int) {
//        balanceSubject.onNext(balance)
//    }
//
//    public func lastBlockInfoUpdated(walletKit: WalletKit, lastBlockInfo: BlockInfo) {
//        lastBlockInfoSubject.onNext(lastBlockInfo)
//    }
//
//    public func progressUpdated(walletKit: WalletKit, progress: Double) {
//        progressSubject.onNext(progress)
//    }
//
//}
