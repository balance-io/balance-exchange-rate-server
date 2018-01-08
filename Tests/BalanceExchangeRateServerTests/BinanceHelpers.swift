//
//  BinanceHelpers.swift
//  BalanceExchangeRateServerTests
//
//  Created by Benjamin Baron on 12/1/17.
//

import Foundation

extension TestHelpers {
    
    static var binanceData: Data {
        let jsonData = TestHelpers.binanceApiResponse.data(using: .utf8)!
        return jsonData
    }
    
    static var binanceSimpleData: Data {
        let jsonData = TestHelpers.binanceSimpleResponse.data(using: .utf8)!
        return jsonData
    }
    
    static let binanceSimpleResponse = """
    [
      {
        "symbol": "ETHBTC",
        "price": "0.04255500"
      }
    ]
    """
    
    static let binanceApiResponse = """
    [
      {
        "symbol": "ETHBTC",
        "price": "0.04255500"
      },
      {
        "symbol": "LTCBTC",
        "price": "0.00872900"
      },
      {
        "symbol": "BNBBTC",
        "price": "0.00018937"
      },
      {
        "symbol": "NEOBTC",
        "price": "0.00332000"
      },
      {
        "symbol": "123456",
        "price": "0.00030000"
      },
      {
        "symbol": "QTUMETH",
        "price": "0.02753400"
      },
      {
        "symbol": "EOSETH",
        "price": "0.00679800"
      },
      {
        "symbol": "SNTETH",
        "price": "0.00012950"
      },
      {
        "symbol": "BNTETH",
        "price": "0.00545400"
      },
      {
        "symbol": "BCCBTC",
        "price": "0.13171300"
      },
      {
        "symbol": "GASBTC",
        "price": "0.00183000"
      },
      {
        "symbol": "BNBETH",
        "price": "0.00445455"
      },
      {
        "symbol": "BTMETH",
        "price": "0.00018900"
      },
      {
        "symbol": "HCCBTC",
        "price": "0.00000180"
      },
      {
        "symbol": "BTCUSDT",
        "price": "10536.00000000"
      },
      {
        "symbol": "ETHUSDT",
        "price": "448.54000000"
      },
      {
        "symbol": "HSRBTC",
        "price": "0.00153400"
      },
      {
        "symbol": "OAXETH",
        "price": "0.00081190"
      },
      {
        "symbol": "DNTETH",
        "price": "0.00009705"
      },
      {
        "symbol": "MCOETH",
        "price": "0.01375500"
      },
      {
        "symbol": "ICNETH",
        "price": "0.00333840"
      },
      {
        "symbol": "ELCBTC",
        "price": "0.00000053"
      },
      {
        "symbol": "MCOBTC",
        "price": "0.00058200"
      },
      {
        "symbol": "WTCBTC",
        "price": "0.00068008"
      },
      {
        "symbol": "WTCETH",
        "price": "0.01599900"
      },
      {
        "symbol": "LLTBTC",
        "price": "0.00001669"
      },
      {
        "symbol": "LRCBTC",
        "price": "0.00002011"
      },
      {
        "symbol": "LRCETH",
        "price": "0.00047334"
      },
      {
        "symbol": "QTUMBTC",
        "price": "0.00116700"
      },
      {
        "symbol": "YOYOBTC",
        "price": "0.00000858"
      },
      {
        "symbol": "OMGBTC",
        "price": "0.00082000"
      },
      {
        "symbol": "OMGETH",
        "price": "0.01936800"
      },
      {
        "symbol": "ZRXBTC",
        "price": "0.00001914"
      },
      {
        "symbol": "ZRXETH",
        "price": "0.00045000"
      },
      {
        "symbol": "STRATBTC",
        "price": "0.00053200"
      },
      {
        "symbol": "STRATETH",
        "price": "0.01269000"
      },
      {
        "symbol": "SNGLSBTC",
        "price": "0.00001179"
      },
      {
        "symbol": "SNGLSETH",
        "price": "0.00027761"
      },
      {
        "symbol": "BQXBTC",
        "price": "0.00015948"
      },
      {
        "symbol": "BQXETH",
        "price": "0.00366710"
      },
      {
        "symbol": "KNCBTC",
        "price": "0.00010097"
      },
      {
        "symbol": "KNCETH",
        "price": "0.00237950"
      },
      {
        "symbol": "FUNBTC",
        "price": "0.00000257"
      },
      {
        "symbol": "FUNETH",
        "price": "0.00006102"
      },
      {
        "symbol": "SNMBTC",
        "price": "0.00001102"
      },
      {
        "symbol": "SNMETH",
        "price": "0.00025999"
      },
      {
        "symbol": "NEOETH",
        "price": "0.07780800"
      },
      {
        "symbol": "IOTABTC",
        "price": "0.00012984"
      },
      {
        "symbol": "IOTAETH",
        "price": "0.00305310"
      },
      {
        "symbol": "LINKBTC",
        "price": "0.00001626"
      },
      {
        "symbol": "LINKETH",
        "price": "0.00037704"
      },
      {
        "symbol": "XVGBTC",
        "price": "0.00000057"
      },
      {
        "symbol": "XVGETH",
        "price": "0.00001349"
      },
      {
        "symbol": "CTRBTC",
        "price": "0.00004232"
      },
      {
        "symbol": "CTRETH",
        "price": "0.00098380"
      },
      {
        "symbol": "SALTBTC",
        "price": "0.00042600"
      },
      {
        "symbol": "SALTETH",
        "price": "0.00998400"
      },
      {
        "symbol": "MDABTC",
        "price": "0.00013305"
      },
      {
        "symbol": "MDAETH",
        "price": "0.00313910"
      },
      {
        "symbol": "MTLBTC",
        "price": "0.00049000"
      },
      {
        "symbol": "MTLETH",
        "price": "0.01161700"
      },
      {
        "symbol": "SUBBTC",
        "price": "0.00002948"
      },
      {
        "symbol": "SUBETH",
        "price": "0.00069599"
      },
      {
        "symbol": "EOSBTC",
        "price": "0.00028770"
      },
      {
        "symbol": "SNTBTC",
        "price": "0.00000553"
      },
      {
        "symbol": "ETC",
        "price": "1.00000000"
      },
      {
        "symbol": "ETCETH",
        "price": "0.06362200"
      },
      {
        "symbol": "ETCBTC",
        "price": "0.00271400"
      },
      {
        "symbol": "MTHBTC",
        "price": "0.00000535"
      },
      {
        "symbol": "MTHETH",
        "price": "0.00012458"
      },
      {
        "symbol": "ENGBTC",
        "price": "0.00006157"
      },
      {
        "symbol": "ENGETH",
        "price": "0.00143960"
      },
      {
        "symbol": "DNTBTC",
        "price": "0.00000414"
      },
      {
        "symbol": "ZECBTC",
        "price": "0.02990100"
      },
      {
        "symbol": "ZECETH",
        "price": "0.70066000"
      },
      {
        "symbol": "BNTBTC",
        "price": "0.00023400"
      },
      {
        "symbol": "ASTBTC",
        "price": "0.00002369"
      },
      {
        "symbol": "ASTETH",
        "price": "0.00055020"
      },
      {
        "symbol": "DASHBTC",
        "price": "0.07277600"
      },
      {
        "symbol": "DASHETH",
        "price": "1.71563000"
      },
      {
        "symbol": "OAXBTC",
        "price": "0.00003488"
      },
      {
        "symbol": "ICNBTC",
        "price": "0.00014404"
      },
      {
        "symbol": "BTGBTC",
        "price": "0.02801600"
      },
      {
        "symbol": "BTGETH",
        "price": "0.67699700"
      },
      {
        "symbol": "EVXBTC",
        "price": "0.00013135"
      },
      {
        "symbol": "EVXETH",
        "price": "0.00307000"
      },
      {
        "symbol": "REQBTC",
        "price": "0.00000601"
      },
      {
        "symbol": "REQETH",
        "price": "0.00013941"
      },
      {
        "symbol": "VIBBTC",
        "price": "0.00001173"
      },
      {
        "symbol": "VIBETH",
        "price": "0.00027537"
      },
      {
        "symbol": "HSRETH",
        "price": "0.03602700"
      },
      {
        "symbol": "TRXBTC",
        "price": "0.00000019"
      },
      {
        "symbol": "TRXETH",
        "price": "0.00000468"
      },
      {
        "symbol": "POWRBTC",
        "price": "0.00006553"
      },
      {
        "symbol": "POWRETH",
        "price": "0.00154131"
      },
      {
        "symbol": "ARKBTC",
        "price": "0.00030830"
      },
      {
        "symbol": "ARKETH",
        "price": "0.00744900"
      },
      {
        "symbol": "YOYOETH",
        "price": "0.00019615"
      },
      {
        "symbol": "XRPBTC",
        "price": "0.00002311"
      },
      {
        "symbol": "XRPETH",
        "price": "0.00054101"
      },
      {
        "symbol": "MODBTC",
        "price": "0.00019480"
      },
      {
        "symbol": "MODETH",
        "price": "0.00446400"
      },
      {
        "symbol": "ENJBTC",
        "price": "0.00000228"
      },
      {
        "symbol": "ENJETH",
        "price": "0.00005399"
      },
      {
        "symbol": "STORJBTC",
        "price": "0.00006746"
      },
      {
        "symbol": "STORJETH",
        "price": "0.00156000"
      },
      {
        "symbol": "BNBUSDT",
        "price": "2.00000000"
      },
      {
        "symbol": "VENBNB",
        "price": "0.15280000"
      },
      {
        "symbol": "YOYOBNB",
        "price": "0.04450000"
      },
      {
        "symbol": "POWRBNB",
        "price": "0.34626000"
      },
      {
        "symbol": "VENBTC",
        "price": "0.00003010"
      },
      {
        "symbol": "VENETH",
        "price": "0.00068141"
      },
      {
        "symbol": "KMDBTC",
        "price": "0.00025200"
      },
      {
        "symbol": "KMDETH",
        "price": "0.00592100"
      },
      {
        "symbol": "NULSBNB",
        "price": "0.24494000"
      },
      {
        "symbol": "RCNBTC",
        "price": "0.00001165"
      },
      {
        "symbol": "RCNETH",
        "price": "0.00027300"
      },
      {
        "symbol": "RCNBNB",
        "price": "0.06135000"
      },
      {
        "symbol": "NULSBTC",
        "price": "0.00004630"
      },
      {
        "symbol": "NULSETH",
        "price": "0.00108492"
      },
      {
        "symbol": "RDNBTC",
        "price": "0.00035502"
      },
      {
        "symbol": "RDNETH",
        "price": "0.00854290"
      },
      {
        "symbol": "RDNBNB",
        "price": "1.88815000"
      },
      {
        "symbol": "XMRBTC",
        "price": "0.01758700"
      },
      {
        "symbol": "XMRETH",
        "price": "0.42505000"
      },
      {
        "symbol": "DLTBNB",
        "price": "0.11799000"
      },
      {
        "symbol": "WTCBNB",
        "price": "3.60770000"
      },
      {
        "symbol": "DLTBTC",
        "price": "0.00002234"
      },
      {
        "symbol": "DLTETH",
        "price": "0.00052521"
      },
      {
        "symbol": "AMBBTC",
        "price": "0.00002040"
      },
      {
        "symbol": "AMBETH",
        "price": "0.00046642"
      },
      {
        "symbol": "AMBBNB",
        "price": "0.10670000"
      },
      {
        "symbol": "BCCETH",
        "price": "3.08079000"
      },
      {
        "symbol": "BCCUSDT",
        "price": "1391.78000000"
      },
      {
        "symbol": "BCCBNB",
        "price": "696.97000000"
      },
      {
        "symbol": "BATBTC",
        "price": "0.00001594"
      },
      {
        "symbol": "BATETH",
        "price": "0.00037583"
      },
      {
        "symbol": "BATBNB",
        "price": "0.08348000"
      },
      {
        "symbol": "BCPTBTC",
        "price": "0.00002700"
      },
      {
        "symbol": "BCPTETH",
        "price": "0.00063529"
      },
      {
        "symbol": "BCPTBNB",
        "price": "0.14400000"
      },
      {
        "symbol": "ARNBTC",
        "price": "0.00003967"
      },
      {
        "symbol": "ARNETH",
        "price": "0.00092811"
      },
      {
        "symbol": "GVTBTC",
        "price": "0.00060830"
      },
      {
        "symbol": "GVTETH",
        "price": "0.01422400"
      },
      {
        "symbol": "CDTBTC",
        "price": "0.00000397"
      },
      {
        "symbol": "CDTETH",
        "price": "0.00009226"
      },
      {
        "symbol": "GXSBTC",
        "price": "0.00026400"
      },
      {
        "symbol": "GXSETH",
        "price": "0.00613000"
      },
      {
        "symbol": "NEOUSDT",
        "price": "34.90100000"
      },
      {
        "symbol": "NEOBNB",
        "price": "17.46800000"
      },
      {
        "symbol": "POEBTC",
        "price": "0.00000075"
      },
      {
        "symbol": "POEETH",
        "price": "0.00001825"
      },
      {
        "symbol": "QSPBTC",
        "price": "0.00001104"
      },
      {
        "symbol": "QSPETH",
        "price": "0.00026222"
      },
      {
        "symbol": "QSPBNB",
        "price": "0.05795000"
      },
      {
        "symbol": "BTSBTC",
        "price": "0.00001355"
      },
      {
        "symbol": "BTSETH",
        "price": "0.00031645"
      },
      {
        "symbol": "BTSBNB",
        "price": "0.07100000"
      },
      {
        "symbol": "XZCBTC",
        "price": "0.00353300"
      },
      {
        "symbol": "XZCETH",
        "price": "0.08203400"
      },
      {
        "symbol": "XZCBNB",
        "price": "18.03000000"
      },
      {
        "symbol": "LSKBTC",
        "price": "0.00072930"
      },
      {
        "symbol": "LSKETH",
        "price": "0.01700000"
      },
      {
        "symbol": "LSKBNB",
        "price": "3.83430000"
      },
      {
        "symbol": "TNTBTC",
        "price": "0.00000737"
      },
      {
        "symbol": "TNTETH",
        "price": "0.00017021"
      },
      {
        "symbol": "FUELBTC",
        "price": "0.00000391"
      },
      {
        "symbol": "FUELETH",
        "price": "0.00009311"
      },
      {
        "symbol": "MANABTC",
        "price": "0.00000148"
      },
      {
        "symbol": "MANAETH",
        "price": "0.00003470"
      },
      {
        "symbol": "BCDBTC",
        "price": "0.00516900"
      },
      {
        "symbol": "BCDETH",
        "price": "0.12000000"
      },
      {
        "symbol": "DGDBTC",
        "price": "0.00976800"
      },
      {
        "symbol": "DGDETH",
        "price": "0.23036000"
      },
      {
        "symbol": "IOTABNB",
        "price": "0.68899000"
      },
      {
        "symbol": "ADXBTC",
        "price": "0.00011801"
      },
      {
        "symbol": "ADXETH",
        "price": "0.00278010"
      },
      {
        "symbol": "ADXBNB",
        "price": "0.62439000"
      },
      {
        "symbol": "ADABTC",
        "price": "0.00001192"
      },
      {
        "symbol": "ADAETH",
        "price": "0.00028350"
      },
      {
        "symbol": "PPTBTC",
        "price": "0.00118590"
      },
      {
        "symbol": "PPTETH",
        "price": "0.02800000"
      }
    ]
    """
}
