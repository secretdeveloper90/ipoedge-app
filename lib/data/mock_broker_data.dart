const List<Map<String, dynamic>> mockBrokerData = [
  {
    "id": "1",
    "name": "Zerodha",
    "logo": "https://media.ipoji.com/broker/images/zerodha-logo.jpeg",
    "type": "Discount Broker",
    "activeClients": "78,31,319",
    "about":
        "Zerodha, an Indian discount stockbroker, provides online trading and investment services. Founded in 2010 by Nithin Kamath and Nikhil Kamath, Zerodha has established a substantial presence in the market. As of April 2025, the platform boasts an active client base of 78,31,319.",
    "accountOpening": "Free",
    "accountMaintenance": 300,
    "callTrade": 50,
    "brokerage": {
      "equityDelivery": "Zero",
      "equityIntraday": "0.03% up to Rs 20",
      "equityFutures": "0.03% up to Rs 20",
      "equityOptions": "₹20 per order",
      "currencyFutures": "0.03% up to Rs 20",
      "currencyOptions": "₹20 Per order",
      "commodityFutures": "0.03% up to Rs 20",
      "commodityOptions": "₹20 Per order"
    },
    "margins": {
      "equityDelivery": "0x As per exchange",
      "equityIntraday": "3x As per exchange",
      "equityFutures": "2.5x As per exchange",
      "equityOptions": "2.5x As per exchange",
      "currencyFutures": "2.5x As per exchange",
      "currencyOptions": "2.5x As per exchange",
      "commodityFutures": "2.5x As per exchange",
      "commodityOptions": "0x As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": [
      "Zerodha Kite web",
      "Zerodha Kite Mobile Application",
      "Zerodha Coin",
      "Zerodha Console",
      "Sentinel",
      "Zerodha Varsity"
    ],
    "pros": [
      "Zerodha imposes a minimal trading fee and does not levy any charges for equity delivery.",
      "A fee calculator is available on the Zerodha website, enabling users to anticipate trading costs.",
      "There is no requirement to maintain a minimum balance when opening an account with Zerodha.",
      "The processes for deposits and withdrawals are user-friendly and free of charge.",
      "No platform deposit fee is required. Users can conveniently transfer funds to their accounts via UPI."
    ],
    "cons": [
      "NRIs, HUFs, and companies can open a demat account only through an offline process.",
      "Responses from customer support may be delayed, and software glitches can occur at times.",
      "Each investment instrument has a dedicated platform, such as Kite for shares, Coin for mutual funds, and Golden Pi for bonds.",
      "The offline procedure is cumbersome and time-consuming, even for individual accounts, due to the limited number of physical branches."
    ],
    "additionalFeatures": {
      "3in1Account": false,
      "freeTradingCalls": false,
      "freeResearch": false,
      "smsAlerts": false,
      "marginFunding": false,
      "marginAgainstShare": false
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "bonds debt",
      "exchange traded funds"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "0.00375%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.1%",
        "sebiCharges": "₹ 10 per crore + GST"
      },
      "intraday": {
        "transactionCharges": {"BSE": "0.00375%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "₹ 0",
        "gst": "18% on Brokerage + Transaction + SEBI Charges",
        "stt": "0.025%",
        "sebiCharges": "₹ 10 per crore + GST"
      },
      "futures": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "",
        "dpCharge": "₹ 0",
        "gst": "18% on Brokerage + Transaction + SEBI Charges",
        "stt": "0.02%",
        "sebiCharges": "₹ 10 per crore + GST"
      },
      "options": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "",
        "dpCharge": "₹ 0",
        "gst": "18% on Brokerage + Transaction + SEBI Charges",
        "stt": "0.1%",
        "sebiCharges": "₹ 10 per crore + GST"
      }
    },
    "rating": 4.5,
    "features": [
      "Free account opening",
      "Zero brokerage on equity delivery",
      "Advanced trading platforms",
      "Educational resources",
      "Mobile app"
    ],
    "equityDelivery": "Zero",
    "equityIntraday": "0.03%"
  },
  {
    "id": "2",
    "name": "Angel One",
    "logo": "https://media.ipoji.com/broker/images/angel-logo.jpeg",
    "type": "Full Service Broker",
    "activeClients": "75,02,226",
    "about":
        "Angel One is a full-service broker in India that offers a wide range of investment and trading services at costs comparable to those of discount brokers. As of April 2025, Angel One has an active client base of 75,02,226.",
    "accountOpening": "Free",
    "accountMaintenance": 240,
    "callTrade": 20,
    "brokerage": {
      "equityDelivery": "Zero",
      "equityIntraday": "0.03% up to Rs 20",
      "equityFutures": "₹20 up to Rs 20",
      "equityOptions": "₹20 per order or 25%, whichever is lower",
      "currencyFutures": "₹20 up to Rs 20",
      "currencyOptions": "₹20 per order or 25%, whichever is lower",
      "commodityFutures": "₹20 up to Rs 20",
      "commodityOptions": "₹20 per order or 25%, whichever is lower"
    },
    "margins": {
      "equityDelivery": "1x As per exchange",
      "equityIntraday": "4x As per exchange",
      "equityFutures": "4x As per exchange",
      "equityOptions": "3x/4x As per exchange",
      "currencyFutures": "4x As per exchange",
      "currencyOptions": "3x/4x As per exchange",
      "commodityFutures": "4x As per exchange",
      "commodityOptions": "0x As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": [
      "Angel Speed Pro",
      "Angel One Trade",
      "Angel One App",
      "Angel ARQ"
    ],
    "pros": [
      "Offers full-service brokerage services at low fees.",
      "Charges a flat brokerage fee of only ₹20 across all segments.",
      "Provides free tips on ARQ, the robo-advisory app.",
      "Offers free advisory tips for mutual funds and equities.",
      "Provides an option to invest in corporate bonds."
    ],
    "cons": [
      "It does not offer the facility of a 3-in-1 account.",
      "GTC and GTT facilities are not available.",
      "The cost of broker-assisted trades (call and trade) is ₹20 per executed transaction.",
      "Reviews indicate consistent cross-selling pressure from Angel One's relationship managers to purchase additional products."
    ],
    "additionalFeatures": {
      "3in1Account": false,
      "freeTradingCalls": false,
      "freeResearch": false,
      "smsAlerts": false,
      "marginFunding": false,
      "marginAgainstShare": false
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "bonds debt",
      "exchange traded funds",
      "insurance"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.1% on both buy & sell",
        "sebiCharges": "₹ 10 per crore"
      },
      "intraday": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "₹ 0",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.025% only on sell",
        "sebiCharges": "₹ 10 per crore"
      },
      "futures": {
        "transactionCharges": {"BSE": "%", "NSE": ""},
        "clearingCharges": "",
        "dpCharge": "₹ 0",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.02%",
        "sebiCharges": "₹ 10 per crore"
      },
      "options": {
        "transactionCharges": {
          "BSE":
              "Sensex 50/Stock options 0.0050%, Sensex/Bankex options 0.0325%",
          "NSE": ""
        },
        "clearingCharges": "",
        "dpCharge": "₹ 0",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.1%",
        "sebiCharges": "₹ 10 per crore"
      }
    },
    "rating": 4.3,
    "features": [
      "Free account opening",
      "Zero brokerage on equity delivery",
      "Research reports",
      "Portfolio management",
      "Mobile trading"
    ],
    "equityDelivery": "Zero",
    "equityIntraday": "0.03%"
  },
  {
    "id": "3",
    "name": "Upstox",
    "logo": "https://media.ipoji.com/broker/images/upstox-logo.jpeg",
    "type": "Discount Broker",
    "activeClients": "27,01,041",
    "about":
        "Backed by Tiger Global and Ratan Tata, Upstox is a discount broker that offers free third-party premium subscriptions upon account opening. As of April 2025, Upstox has an active client base of 27,01,041.",
    "accountOpening": "Free",
    "accountMaintenance": 0,
    "callTrade": 50,
    "brokerage": {
      "equityDelivery": "₹20 per order",
      "equityIntraday": "0.05% up to Rs 20",
      "equityFutures": "0.05% up to Rs 20",
      "equityOptions": "₹20 per order",
      "currencyFutures": "0.05% up to Rs 20",
      "currencyOptions": "₹20 per order",
      "commodityFutures": "0.05% up to Rs 20",
      "commodityOptions": "₹20 per order"
    },
    "margins": {
      "equityDelivery": "4x As per exchange",
      "equityIntraday": "5x As per exchange",
      "equityFutures": "1x As per exchange",
      "equityOptions": "1x As per exchange",
      "currencyFutures": "1x As per exchange",
      "currencyOptions": "1x As per exchange",
      "commodityFutures": "1x As per exchange",
      "commodityOptions": "1x As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": ["Pro Web Trading Platform", "Upstox Pro Mobile"],
    "pros": [
      "The early morning newsletter from Upstox is meticulously crafted, offering excellent insights and a comprehensive market recap.",
      "Upstox provides delivery transactions at no cost, charges flat trading fees, and offers margining against held shares.",
      "A wide array of knowledge resources is available, encompassing both technical analysis and basic investing principles.",
      "Users can easily toggle between the TradingView and ChartsIQ libraries."
    ],
    "cons": [
      "NRIs, HUFs, and companies can open a demat account only through an offline process.",
      "Customers must exercise caution when selecting mutual funds, as both direct and regular plans are available.",
      "An additional fee of ₹20 per executed order is charged for intraday square-off orders if they are not squared off by the customer."
    ],
    "additionalFeatures": {
      "3in1Account": false,
      "freeTradingCalls": false,
      "freeResearch": false,
      "smsAlerts": false,
      "marginFunding": false,
      "marginAgainstShare": true
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "bonds debt",
      "exchange traded funds",
      "insurance"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "Sell side, ₹ 18.5 per scrip",
        "gst": "18% on Brokerage + Transaction + Demat Charges",
        "stt": "0.1%",
        "sebiCharges": "₹ 10 per crore"
      },
      "intraday": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "₹ 0",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.025%",
        "sebiCharges": "₹ 10 per crore"
      },
      "futures": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "₹ 0",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.02%",
        "sebiCharges": "₹ 10 per crore"
      },
      "options": {
        "transactionCharges": {"BSE": "0.0495%", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "₹ 0",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.1%",
        "sebiCharges": "₹ 10 per crore"
      }
    },
    "rating": 4.2,
    "features": [
      "Free account opening",
      "No AMC charges",
      "Low brokerage rates",
      "User-friendly platform",
      "Quick onboarding"
    ],
    "equityDelivery": 20,
    "equityIntraday": "0.05%"
  },
  {
    "id": "4",
    "name": "Dhan",
    "logo": "https://media.ipoji.com/broker/images/dhan-logo.jpeg",
    "type": "Discount Broker",
    "activeClients": "9,82,814",
    "about":
        "Dhan is one of India's fastest-growing technology and product-led stock broking platforms, providing a lightning-fast investing and trading experience to its users. As of April 2025, Dhan has an active client base of 9,82,814.",
    "accountOpening": "Free",
    "accountMaintenance": "Free",
    "callTrade": 50,
    "brokerage": {
      "equityDelivery": "Zero",
      "equityIntraday": "0.03% up to Rs 20",
      "equityFutures": "0.03% up to Rs 20",
      "equityOptions": "₹20 per order",
      "currencyFutures": "-",
      "currencyOptions": "-",
      "commodityFutures": "0.03% up to Rs 20",
      "commodityOptions": "₹20 Per order"
    },
    "margins": {
      "equityDelivery": "1x As per exchange",
      "equityIntraday": "5x As per exchange",
      "equityFutures": "1x As per exchange",
      "equityOptions": "1x As per exchange",
      "currencyFutures": "-",
      "currencyOptions": "-",
      "commodityFutures": "1x As per exchange",
      "commodityOptions": "1x As per exchange"
    },
    "services": ["Equity", "Commodity", "Futures", "Options"],
    "platforms": [
      "Dhan Mobile Application",
      "Dhan Web Trading Platform",
      "Options Trader"
    ],
    "pros": [
      "Accessible through multiple platforms including a Mobile App, Web interface, and Trading View charting platform.",
      "No inconvenience of SPAM calls, messages, or emails.",
      "Round-the-clock customer care dedicated to addressing all customer grievances.",
      "Offers a 50% discount on brokerage fees for women's participation."
    ],
    "cons": [
      "There is a relatively high charge of ₹50 for every call and trade placed.",
      "The platform is not suitable for new or beginner traders and investors.",
      "There are no dedicated relationship managers for portfolio management services.",
      "No complimentary research reports, stock tips, or weekly recommendations are provided.",
      "There is no option to invest in mutual funds, insurance, bonds, or debt instruments."
    ],
    "additionalFeatures": {
      "3in1Account": false,
      "freeTradingCalls": false,
      "freeResearch": false,
      "smsAlerts": false,
      "marginFunding": false,
      "marginAgainstShare": false
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "exchange traded funds"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "0.00345%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "Free",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.1%",
        "sebiCharges": "0.0001%"
      },
      "intraday": {
        "transactionCharges": {"BSE": "0.00345%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.025%",
        "sebiCharges": "0.0001%"
      },
      "futures": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.02% Sell side",
        "sebiCharges": "0.0001%"
      },
      "options": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.1% Sell side",
        "sebiCharges": "0.0001%"
      }
    },
    "rating": 4.4,
    "features": [
      "Free account opening",
      "Free AMC",
      "Zero brokerage on equity delivery",
      "Advanced charting",
      "Options strategies"
    ],
    "equityDelivery": "Zero",
    "equityIntraday": "0.03%"
  },
  {
    "id": "5",
    "name": "Kotak Securities",
    "logo": "https://media.ipoji.com/broker/images/kotak-sec-logo.jpeg",
    "type": "Full Service Broker",
    "activeClients": "14,72,456",
    "about":
        "Kotak Securities Limited, a subsidiary of Kotak Mahindra Bank Limited, is one of the leading stockbrokers in India. The company offers a wide range of trading and investment services, including research and advisory services, portfolio management services, wealth management, and more. As of April 2025, Kotak Securities has an active client base of 14,72,456.",
    "accountOpening": 99,
    "accountMaintenance": 0,
    "callTrade": 49,
    "planCharges": 49,
    "brokerage": {
      "equityDelivery": "0",
      "equityIntraday": "₹10",
      "equityFutures": "₹10",
      "equityOptions": "₹10",
      "currencyFutures": "₹10",
      "currencyOptions": "₹10",
      "commodityFutures": "₹10",
      "commodityOptions": "₹10"
    },
    "margins": {
      "equityDelivery": "5x As per exchange",
      "equityIntraday": "5x As per exchange",
      "equityFutures": "4x As per exchange",
      "equityOptions": "1x/5x Buy 1x , Sell 5x",
      "currencyFutures": "40x As per exchange",
      "currencyOptions": "1x/40x Buy 1 x , Sell 40x",
      "commodityFutures": "8x As per exchange",
      "commodityOptions": "6x As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": [
      "KEAT Pro X",
      "Kotak Stock Trader",
      "Kotak Securities website",
      "Kotak Neo"
    ],
    "pros": [
      "Kotak Securities offers a wide range of investment options, including equity, debt instruments, mutual funds, and derivatives.",
      "The company provides daily alerts, market pointers, research reports, and stock recommendations to its customers.",
      "Customers have the option to make international investments, such as investing in US stocks.",
      "NRIs are also eligible to open an account with Kotak Securities.",
      "Call and email support are available to address customer queries."
    ],
    "cons": [
      "Call & Trade charges vary depending on the frequency of investments.",
      "In the online process, it supports accounts only with scheduled banks.",
      "The offline account opening process is time-consuming and cumbersome.",
      "It has comparatively higher charges for equity delivery."
    ],
    "additionalFeatures": {
      "3in1Account": true,
      "freeTradingCalls": false,
      "freeResearch": true,
      "smsAlerts": true,
      "marginFunding": true,
      "marginAgainstShare": true
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "bonds debt",
      "exchange traded funds",
      "insurance"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "0.00375%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges":
            "0.04% of the value of securities (subject to minimum of Rs.20)",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.1%",
        "sebiCharges": "Rs 10 per crore"
      },
      "intraday": {
        "transactionCharges": {"BSE": "0.00375%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.025%- sell side",
        "sebiCharges": "Rs 10 per crore"
      },
      "futures": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "",
        "dpCharge": "--",
        "gst": "--",
        "stt": "0.02% - Sell-side",
        "sebiCharges": "Rs 10 per crore"
      },
      "options": {
        "transactionCharges": {"BSE": "0.0325%", "NSE": ""},
        "clearingCharges": "",
        "dpCharge": "₹ 0",
        "gst": "--",
        "stt": "0.1% - Sell-side",
        "sebiCharges": "Rs 10 per crore"
      }
    },
    "rating": 4.1,
    "features": [
      "Established brand",
      "Research and advisory",
      "Multiple trading platforms",
      "Banking integration",
      "Customer support"
    ],
    "equityDelivery": 0,
    "equityIntraday": "₹10"
  },
  {
    "id": "6",
    "name": "Groww",
    "logo": "https://media.ipoji.com/broker/images/groww.jpeg",
    "type": "Discount Broker",
    "activeClients": "1,28,48,251",
    "about":
        "Armed with a vision to democratize investing and make it accessible and user-friendly, the four ambitious minds from Flipkart—Lalit Keshre, Harsh Jain, Ishan Bansal, and Neeraj Singh—founded Groww in 2017. In just seven years, Groww became India's number one stock broker, boasting the highest number of active investors. As of April 2025, Groww has an active client base of 1,28,48,251.",
    "accountOpening": "Free",
    "accountMaintenance": "Free",
    "callTrade": "-",
    "brokerage": {
      "equityDelivery": "0.1% up to Rs 20",
      "equityIntraday": "0.1% up to Rs 20",
      "equityFutures": "₹20 per order",
      "equityOptions": "₹20 per order",
      "currencyFutures": "-",
      "currencyOptions": "-",
      "commodityFutures": "-",
      "commodityOptions": "-"
    },
    "margins": {
      "equityDelivery": "- As per exchange",
      "equityIntraday": "- As per exchange",
      "equityFutures": "- As per exchange",
      "equityOptions": "- As per exchange",
      "currencyFutures": "-",
      "currencyOptions": "-",
      "commodityFutures": "-",
      "commodityOptions": "-"
    },
    "services": ["Equity", "Futures", "Options"],
    "platforms": ["Website", "Groww App"],
    "pros": [
      "Mutual fund investments are commission-free for customers.",
      "The process of opening a trading and Demat account is quick and straightforward.",
      "Users also have the option to purchase US equities, US ETFs, US fixed deposits, and digital gold.",
      "The platform offers a simple and intuitive user interface."
    ],
    "cons": [
      "Groww does not provide commodity and currency trading options.",
      "The platform does not offer analysis, trading advice, or recommendations.",
      "Advanced order types such as GTT, Bracket, Cover orders, and AMO orders are not available.",
      "It does not offer research reports on stocks."
    ],
    "additionalFeatures": {
      "3in1Account": false,
      "freeTradingCalls": false,
      "freeResearch": false,
      "smsAlerts": false,
      "marginFunding": false,
      "marginAgainstShare": false
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "exchange traded funds"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "0.00375%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "₹ 16.5 per company",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.02%",
        "sebiCharges": "0.0001%"
      },
      "intraday": {
        "transactionCharges": {"BSE": "0.00375%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "₹ 0",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.025%",
        "sebiCharges": "0.0001%"
      },
      "futures": {
        "transactionCharges": {"BSE": "0%", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "₹ 0",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.02%",
        "sebiCharges": "0.0001%"
      },
      "options": {
        "transactionCharges": {"BSE": "0.00325%", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "₹ 0",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.02%",
        "sebiCharges": "0.0001%"
      }
    },
    "rating": 4.2,
    "features": [
      "Simple interface",
      "Free account opening",
      "Mutual fund platform",
      "Educational content",
      "User-friendly design"
    ],
    "equityDelivery": "Zero",
    "equityIntraday": "0.1%"
  },
  {
    "id": "7",
    "name": "HDFC Securities",
    "logo": "https://media.ipoji.com/broker/images/hdfc-sec-logo.jpeg",
    "type": "Full Service Broker",
    "activeClients": "15,33,800",
    "about":
        "HDFC Securities, the brokerage arm of India's leading private bank HDFC, was launched in 2000. Over the years, it has grown to be recognized as one of the top full-service brokers in India. As of April 2025, HDFC Securities has an active client base of 15,33,800.",
    "accountOpening": "Free",
    "accountMaintenance": "Free",
    "callTrade": "Free",
    "brokerage": {
      "equityDelivery": "0.5% up to Rs 25",
      "equityIntraday": "0.10% up to Rs 25",
      "equityFutures": "0.025% on order value",
      "equityOptions": "₹100 per order",
      "currencyFutures": "₹12",
      "currencyOptions": "₹10",
      "commodityFutures": "₹20",
      "commodityOptions": "₹100"
    },
    "margins": {
      "equityDelivery": "0x As per exchange",
      "equityIntraday": "4x As per exchange",
      "equityFutures": "0x As per exchange",
      "equityOptions": "0x As per exchange",
      "currencyFutures": "0x As per exchange",
      "currencyOptions": "0x As per exchange",
      "commodityFutures": "0x As per exchange",
      "commodityOptions": "0x As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": [
      "HDFC Securities Pro Terminal",
      "HDFC Money",
      "HDFC Securities App"
    ],
    "pros": [
      "The platform offers a 3-in-1 account facility for managing all financial transactions in one centralized location.",
      "It provides automated chat support through ARYA, an intelligent virtual assistant.",
      "Users can access multiple tools and services, including HDFC Blink and portfolio analyzers, for monitoring their investments.",
      "A portfolio tracking system is available to monitor the overall investment and trading portfolio.",
      "There is an option to purchase Indian stocks as well as US stocks and exchange-traded funds for global investing."
    ],
    "cons": [
      "HDFC brokerage rates are relatively high, but they are negotiable for investors who trade in high volumes.",
      "HDFC Blink, the terminal-based trading platform, is available through a chargeable subscription model.",
      "The SMS-based tips and research services are paid services."
    ],
    "additionalFeatures": {
      "3in1Account": true,
      "freeTradingCalls": true,
      "freeResearch": false,
      "smsAlerts": false,
      "marginFunding": true,
      "marginAgainstShare": true
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "bonds debt",
      "exchange traded funds",
      "insurance"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "Sell-side, ₹ 18.5 per scrip",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.1%",
        "sebiCharges": "₹ 15 per crore"
      },
      "intraday": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "₹ 0",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.025%",
        "sebiCharges": "₹ 15 per crore"
      },
      "futures": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "₹ 0",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.02%",
        "sebiCharges": "₹ 15 per crore"
      },
      "options": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "₹ 0",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.05%",
        "sebiCharges": "₹ 15 per crore"
      }
    },
    "rating": 3.9,
    "features": [
      "Trusted brand",
      "Research and analysis",
      "Investment products",
      "Banking services",
      "Customer support"
    ],
    "equityDelivery": "0.5%",
    "equityIntraday": "0.10%"
  },
  {
    "id": "8",
    "name": "ICICI Direct",
    "logo": "https://media.ipoji.com/broker/images/icici-sec-logo.jpeg",
    "type": "Full Service Broker",
    "activeClients": "19,47,209",
    "about":
        "ICICI Securities Limited is a member of the nationally renowned ICICI Group. ICICI Direct, a prominent division of ICICI Securities, provides a wide array of investment options, including stocks, mutual funds, bonds, and more. As of April 2025, ICICI Direct has an active client base of 19,47,209.",
    "accountOpening": "Free",
    "accountMaintenance": 700,
    "callTrade": 50,
    "brokerage": {
      "equityDelivery": "0.25% on order value",
      "equityIntraday": "0.025% on order value",
      "equityFutures": "0.025% on order value",
      "equityOptions": "₹35 per order",
      "currencyFutures": "₹20",
      "currencyOptions": "₹20",
      "commodityFutures": "₹20",
      "commodityOptions": "₹20"
    },
    "margins": {
      "equityDelivery": "- As per exchange",
      "equityIntraday": "- As per exchange",
      "equityFutures": "- As per exchange",
      "equityOptions": "- As per exchange",
      "currencyFutures": "- As per exchange",
      "currencyOptions": "- As per exchange",
      "commodityFutures": "- As per exchange",
      "commodityOptions": "- As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": ["Market App", "Trade Racer", "i-Track", "Money App"],
    "pros": [
      "Access a single website to invest online in mutual funds, IPOs, postal savings schemes, and GOI bonds.",
      "Experience a reduced bandwidth website for trading on smartphones or slower internet connections.",
      "Technical analysis and stock tips are offered to customers at no charge.",
      "Enjoy the convenience of placing multiple orders with Basket Order functionality.",
      "Utilize the featured platform, Sensibull, for options trading."
    ],
    "cons": [
      "ICICI Direct imposes high brokerage fees across various plans.",
      "A premium plan is necessary to access preferred brokerage rates.",
      "Higher brokerage fees are charged by ICICI Direct to customers who trade in penny stocks.",
      "The charge for call & trade is high (after exhausting the first 20 free calls in a month).",
      "There is no provision for free mutual fund investments."
    ],
    "additionalFeatures": {
      "3in1Account": true,
      "freeTradingCalls": true,
      "freeResearch": true,
      "smsAlerts": true,
      "marginFunding": true,
      "marginAgainstShare": true
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "bonds debt",
      "exchange traded funds",
      "insurance"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "₹ 18.5 per company",
        "gst": "18% on Brokerage + Transaction + Demat Charges",
        "stt": "0.1%",
        "sebiCharges": "₹ 5 per crore"
      },
      "intraday": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.025%",
        "sebiCharges": "₹ 5 per crore"
      },
      "futures": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction + Clearing Charges",
        "stt": "0.02%",
        "sebiCharges": "₹ 5 per crore"
      },
      "options": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction + Clearing Charges",
        "stt": "0.1%",
        "sebiCharges": "₹ 5 per crore"
      }
    },
    "rating": 4,
    "features": [
      "Banking integration",
      "Research reports",
      "Investment advisory",
      "Multiple platforms",
      "Comprehensive services"
    ],
    "equityDelivery": "0.25%",
    "equityIntraday": "0.025%"
  },
  {
    "id": "9",
    "name": "Paytm Money",
    "logo": "https://media.ipoji.com/broker/images/paytm-money-logo.jpeg",
    "type": "Discount Broker",
    "activeClients": "6,89,602",
    "about":
        "Paytm Money is an online investment platform that enables users to invest in stocks, mutual funds, NPS, and other financial products. Launched in 2017 by One97 Communications, the parent company of Paytm—India's largest digital payments company—Paytm Money has grown significantly. As of April 2025, the platform has an active client base of 6,89,602.",
    "accountOpening": "Free",
    "accountMaintenance": "Free",
    "callTrade": 100,
    "brokerage": {
      "equityDelivery": "₹20 per order",
      "equityIntraday": "0.05% up to Rs 10",
      "equityFutures": "0.02% up to Rs 15",
      "equityOptions": "₹20 per order",
      "currencyFutures": "NA",
      "currencyOptions": "NA",
      "commodityFutures": "NA",
      "commodityOptions": "NA"
    },
    "margins": {
      "equityDelivery": "1x As per exchange",
      "equityIntraday": "7.5x As per exchange",
      "equityFutures": "1x As per exchange",
      "equityOptions": "1x As per exchange",
      "currencyFutures": "NA As per exchange",
      "currencyOptions": "NA As per exchange",
      "commodityFutures": "NA As per exchange",
      "commodityOptions": "NA As per exchange"
    },
    "services": ["Equity", "Futures", "Options"],
    "platforms": [
      "Paytm Web Trading Platform",
      "Paytm Money Mobile Application"
    ],
    "pros": [
      "The platform employs a two-factor authentication system to ensure the safety of your details.",
      "It features a user-friendly interface for quick analysis of required information.",
      "The platform includes an in-house brokerage calculator and offers Mutual Fund Investment Advisory services.",
      "It offers convenient online opening and operation of a trading account."
    ],
    "cons": [
      "There is no branch or customer support available.",
      "The broker does not provide an NRI trading account.",
      "Commodity and currency trading options are not available.",
      "There is no facility for margin against shares.",
      "The platform exclusively offers direct mutual fund plans."
    ],
    "additionalFeatures": {
      "3in1Account": false,
      "freeTradingCalls": false,
      "freeResearch": false,
      "smsAlerts": false,
      "marginFunding": false,
      "marginAgainstShare": false
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "bonds debt",
      "exchange traded funds"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "0.00300%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "Sell-side, ₹ 250 per 100 shares",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.1% on buy & sell",
        "sebiCharges": "0.00005%"
      },
      "intraday": {
        "transactionCharges": {"BSE": "0.00300%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.025% Sell-side",
        "sebiCharges": "0.00005%"
      },
      "futures": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.02% Sell side",
        "sebiCharges": "0.00005%"
      },
      "options": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.1% Sell side",
        "sebiCharges": "0.00005%"
      }
    },
    "rating": 3.7,
    "features": [
      "Digital-first approach",
      "Free account opening",
      "Mutual fund platform",
      "Easy onboarding",
      "Mobile-centric"
    ],
    "equityDelivery": "₹20",
    "equityIntraday": "0.05%"
  },
  {
    "id": "10",
    "name": "5 Paisa",
    "logo": "https://media.ipoji.com/broker/images/5paisa-logo.jpeg",
    "type": "Discount Broker",
    "activeClients": "4,15,011",
    "about":
        "5paisa is a discount broker that offers a range of tools and features tailored to both traders and investors. It is one of the fastest-growing discount brokers in India. As of April 2025, 5paisa has an active client base of 4,15,011.",
    "accountOpening": "Free",
    "accountMaintenance": 300,
    "callTrade": "Free",
    "brokerage": {
      "equityDelivery": "₹20 per order",
      "equityIntraday": "₹20 per order",
      "equityFutures": "₹20 per order",
      "equityOptions": "₹20 per order",
      "currencyFutures": "₹20 per order",
      "currencyOptions": "₹10 per order",
      "commodityFutures": "₹20 per order",
      "commodityOptions": "₹20 per order"
    },
    "margins": {
      "equityDelivery": "5x As per exchange",
      "equityIntraday": "5x As per exchange",
      "equityFutures": "0x As per exchange",
      "equityOptions": "0x As per exchange",
      "currencyFutures": "0x As per exchange",
      "currencyOptions": "0x As per exchange",
      "commodityFutures": "0x As per exchange",
      "commodityOptions": "0x As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": [
      "Mobile Trading App",
      "Trade Station Web",
      "Trade Station EXE"
    ],
    "pros": [
      "5Paisa's brokerage plans cater to a wide range of individuals, including novices, investors, and professional traders.",
      "It provides an all-in-one account for investing in stocks, mutual funds, commodities, currency, along with research and advisory services.",
      "The platform offers free technical, derivative, and fundamental research alongside an advanced trading platform tailored for traders.",
      "It also includes complimentary stock research and advisory services."
    ],
    "cons": [
      "Exchange transaction charges are higher compared to other discount brokers.",
      "Call & Trade is available but at a significant additional cost.",
      "5Paisa does not provide NRI trading services."
    ],
    "additionalFeatures": {
      "3in1Account": true,
      "freeTradingCalls": true,
      "freeResearch": true,
      "smsAlerts": true,
      "marginFunding": true,
      "marginAgainstShare": true
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "bonds debt",
      "exchange traded funds",
      "insurance"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "0.00345%", "NSE": ""},
        "clearingCharges": "",
        "dpCharges": "0.06% per day",
        "gst": "18% on Brokerage + Transaction + Demat Charges",
        "stt": "0.10%",
        "sebiCharges": "0.00010%"
      },
      "intraday": {
        "transactionCharges": {"BSE": "0.00345%", "NSE": ""},
        "clearingCharges": "",
        "dpCharge": "0.06% per day",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.03%",
        "sebiCharges": "0.00010%"
      },
      "futures": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "0.06% per day",
        "gst": "18% on Brokerage + Transaction + Clearing Charges",
        "stt": "0.02% (Sell Future)",
        "sebiCharges": "0.00010%"
      },
      "options": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "0.06% per day",
        "gst": "18% on Brokerage + Transaction + Clearing Charges",
        "stt": "0.1%",
        "sebiCharges": "0.00010%"
      }
    },
    "rating": 3.8,
    "features": [
      "Flat fee structure",
      "Multiple platforms",
      "Research tools",
      "Mobile trading",
      "Customer support"
    ],
    "equityDelivery": "₹20",
    "equityIntraday": "₹20"
  },
  {
    "id": "11",
    "name": "Stoxkart",
    "logo": "https://media.ipoji.com/broker/images/stoxKart-logo.jpeg",
    "type": "Discount Broker",
    "activeClients": "13,031",
    "about":
        "Backed by the SMC group, Stoxkart offers trading and investing in various segments at a flat rate of brokerage.",
    "accountOpening": 0,
    "accountMaintenance": 300,
    "callTrade": 20,
    "brokerage": {
      "equityDelivery": "Zero",
      "equityIntraday": "₹15 per order",
      "equityFutures": "₹15 per order",
      "equityOptions": "₹15 per order",
      "currencyFutures": "₹15 per order",
      "currencyOptions": "₹15 per order",
      "commodityFutures": "₹15 per order",
      "commodityOptions": "₹15 per order"
    },
    "margins": {
      "equityDelivery": "4x As per exchange",
      "equityIntraday": "33x As per exchange",
      "equityFutures": "4x As per exchange",
      "equityOptions": "4x As per exchange",
      "currencyFutures": "4x As per exchange",
      "currencyOptions": "4x As per exchange",
      "commodityFutures": "4x As per exchange",
      "commodityOptions": "0x As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": [
      "Stoxkart Classic Mobile Application",
      "Browser-Based Trading",
      "Desktop trading application"
    ],
    "pros": [
      "Low brokerage charges",
      "Free stock recommendations",
      "Real-time data"
    ],
    "cons": [
      "Additional costs for Call & Trade",
      "Data-intensive app",
      "Basic interface"
    ],
    "additionalFeatures": {
      "3in1Account": false,
      "freeTradingCalls": false,
      "freeResearch": true,
      "smsAlerts": false,
      "marginFunding": false,
      "marginAgainstShare": false
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "bonds debt",
      "exchange traded funds",
      "insurance"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "0.00375%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.1%",
        "sebiCharges": "₹ 10 per crore"
      },
      "intraday": {
        "transactionCharges": {"BSE": "0.00375%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.025%",
        "sebiCharges": "₹ 10 per crore"
      },
      "futures": {
        "transactionCharges": {"BSE": "0.00050%", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.02% - Sell-side",
        "sebiCharges": "₹ 10 per crore"
      },
      "options": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.1% Sell side",
        "sebiCharges": "₹ 10 per crore"
      }
    },
    "rating": 3.6,
    "features": [
      "Zero account opening",
      "Zero delivery charges",
      "Competitive rates",
      "Trading platform",
      "Customer support"
    ],
    "equityDelivery": "Zero",
    "equityIntraday": "₹15"
  },
  {
    "id": "12",
    "name": "MSTOCK",
    "logo": "https://media.ipoji.com/broker/images/mStock-logo.jpeg",
    "type": "Discount Broker",
    "activeClients": "5,02,584",
    "about":
        "Launched in April 2022, m.Stock is the broking platform created by the renowned Asset Management Company, Mirae Asset.",
    "accountOpening": 0,
    "accountMaintenance": "Free",
    "callTrade": "Free",
    "brokerage": {
      "equityDelivery": "Zero",
      "equityIntraday": "₹5",
      "equityFutures": "₹5",
      "equityOptions": "₹5",
      "currencyFutures": "₹5",
      "currencyOptions": "₹5",
      "commodityFutures": "-",
      "commodityOptions": "-"
    },
    "margins": {
      "equityDelivery": "₹5 As per exchange",
      "equityIntraday": "₹5 As per exchange",
      "equityFutures": "₹5 As per exchange",
      "equityOptions": "₹5 As per exchange",
      "currencyFutures": "₹5 As per exchange",
      "currencyOptions": "₹5 As per exchange",
      "commodityFutures": "-",
      "commodityOptions": "-"
    },
    "services": ["Equity", "Currency", "Futures", "Options"],
    "platforms": ["Web Portal", "Share Market App"],
    "pros": [
      "Zero brokerage charges",
      "Zero call and trade charges",
      "No annual platform charges",
      "Direct mutual fund plans"
    ],
    "cons": [
      "No analysis or research reports",
      "No commodity trading",
      "Quarterly AMC if not opted for Zero Brokerage plan"
    ],
    "additionalFeatures": {
      "3in1Account": false,
      "freeTradingCalls": true,
      "freeResearch": false,
      "smsAlerts": false,
      "marginFunding": false,
      "marginAgainstShare": false
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "exchange traded funds"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "0.00375%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "Sell-side, ₹ 7 & ₹ 5.5 CDSL",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.1%",
        "sebiCharges": "₹ 10/Crore"
      },
      "intraday": {
        "transactionCharges": {"BSE": "0.00375%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.025% sell side",
        "sebiCharges": "₹ 10/Crore"
      },
      "futures": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.02% sell side",
        "sebiCharges": "₹ 10/Crore"
      },
      "options": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.1% sell side",
        "sebiCharges": "₹ 10/Crore"
      }
    },
    "rating": 3.5,
    "features": [
      "Zero account opening",
      "Free AMC",
      "Zero delivery charges",
      "Low intraday charges",
      "Mobile trading"
    ],
    "equityDelivery": "Zero",
    "equityIntraday": "₹5"
  },
  {
    "id": "13",
    "name": "IIFL Securities",
    "logo": "https://media.ipoji.com/broker/images/iifl-sec-logo.jpeg",
    "type": "Full Service Broker",
    "activeClients": "4,33,847",
    "about":
        "IIFL is a leading financial service provider known for offering a wide range of services and for its well-recognized brand.",
    "accountOpening": "Free",
    "accountMaintenance": 250,
    "callTrade": 20,
    "brokerage": {
      "equityDelivery": "Zero",
      "equityIntraday": "₹20 per order",
      "equityFutures": "₹20 per order",
      "equityOptions": "₹20 per order",
      "currencyFutures": "₹20 per order",
      "currencyOptions": "₹20 per order",
      "commodityFutures": "₹20 per order",
      "commodityOptions": "₹20 per order"
    },
    "margins": {
      "equityDelivery": "4x As per exchange",
      "equityIntraday": "20x As per exchange",
      "equityFutures": "5x As per exchange",
      "equityOptions": "5x As per exchange",
      "currencyFutures": "2x As per exchange",
      "currencyOptions": "1x As per exchange",
      "commodityFutures": "3x As per exchange",
      "commodityOptions": "1x As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": ["IIFL Markets Mobile App", "Trader Terminal", "TT Iris"],
    "pros": [
      "Free reports on mutual fund and equity research",
      "Personal FDs accepted as collateral",
      "Dedicated relationship manager",
      "Well-designed knowledge center"
    ],
    "cons": [
      "Higher brokerage charges",
      "Free equity delivery only in Z20 plan",
      "Delays in Z20 plan support"
    ],
    "additionalFeatures": {
      "3in1Account": true,
      "freeTradingCalls": false,
      "freeResearch": true,
      "smsAlerts": true,
      "marginFunding": true,
      "marginAgainstShare": true
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "bonds debt",
      "exchange traded funds",
      "insurance"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "Sell-side, ₹ 18.5 per script",
        "gst": "18% on Brokerage + Transaction + Demat Charges",
        "stt": "0.1%",
        "sebiCharges": "₹ 10 per crore"
      },
      "intraday": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.025% only on Sell",
        "sebiCharges": "₹ 10 per crore"
      },
      "futures": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction + Clearing Charges",
        "stt": "0.02% only on Sell",
        "sebiCharges": "₹ 10 per crore"
      },
      "options": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction + Clearing Charges",
        "stt": "0.1% sell side",
        "sebiCharges": "₹ 10 per crore"
      }
    },
    "rating": 3.9,
    "features": [
      "Free account opening",
      "Zero delivery charges",
      "Research services",
      "Multiple platforms",
      "Investment advisory"
    ],
    "equityDelivery": "Zero",
    "equityIntraday": "₹20"
  },
  {
    "id": "14",
    "name": "Fyers",
    "logo": "https://media.ipoji.com/broker/images/fyers-logo.jpeg",
    "type": "Discount Broker",
    "activeClients": "2,31,327",
    "about":
        "Founded in 2015 by the Khoday brothers, FYERS is one of the newer entrants in the discount broking market.",
    "accountOpening": "Free",
    "accountMaintenance": "Free",
    "callTrade": 50,
    "brokerage": {
      "equityDelivery": "Zero",
      "equityIntraday": "0.03% up to Rs 20",
      "equityFutures": "0.03% up to Rs 20",
      "equityOptions": "₹20 per order",
      "currencyFutures": "0.03% per order",
      "currencyOptions": "₹20 per order",
      "commodityFutures": "0.03% per order",
      "commodityOptions": "₹20"
    },
    "margins": {
      "equityDelivery": "1x As per exchange",
      "equityIntraday": "5x As per exchange",
      "equityFutures": "1x As per exchange",
      "equityOptions": "1x As per exchange",
      "currencyFutures": "1x As per exchange",
      "currencyOptions": "1x As per exchange",
      "commodityFutures": "1x As per exchange",
      "commodityOptions": "1x As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": [
      "Fyers Web",
      "Fyers App",
      "Fyers One",
      "Fyers Direct",
      "Fyers Thematic"
    ],
    "pros": [
      "Unified margin account",
      "Orders from charts",
      "Largest historical data collection",
      "Wide range of time frames"
    ],
    "cons": [
      "Lacks candlestick indicators",
      "No screeners",
      "Greeks not displayed on charts",
      "No Whatsapp support"
    ],
    "additionalFeatures": {
      "3in1Account": false,
      "freeTradingCalls": false,
      "freeResearch": false,
      "smsAlerts": false,
      "marginFunding": true,
      "marginAgainstShare": true
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "exchange traded funds"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "0.00375%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "Sell-side, ₹ 7 & ₹ 5.5 CDSL",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.1%",
        "sebiCharges": "₹ 10/Crore"
      },
      "intraday": {
        "transactionCharges": {"BSE": "0.00375%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.025% sell side",
        "sebiCharges": "₹ 10/Crore"
      },
      "futures": {
        "transactionCharges": {"BSE": "0%", "NSE": ""},
        "clearingCharges": "",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.02 sell side%",
        "sebiCharges": "₹ 10/Crore"
      },
      "options": {
        "transactionCharges": {"BSE": "0.00375%", "NSE": ""},
        "clearingCharges": "",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Exchange Turn Over Charges",
        "stt": "0.1% sell side",
        "sebiCharges": "₹ 10/Crore"
      }
    },
    "rating": 4,
    "features": [
      "Free account opening",
      "Free AMC",
      "Zero delivery charges",
      "Advanced trading tools",
      "API access"
    ],
    "equityDelivery": "Zero",
    "equityIntraday": "0.03%"
  },
  {
    "id": "15",
    "name": "Motilal Oswal",
    "logo": "https://media.ipoji.com/broker/images/motilal-oswal-logo.jpeg",
    "type": "Full Service Broker",
    "activeClients": "10,08,049",
    "about":
        "Motilal Oswal Financial Services Limited is an Indian financial services company that offers a wide range of financial products and services.",
    "accountOpening": "Free",
    "accountMaintenance": 199,
    "callTrade": "Free",
    "brokerage": {
      "equityDelivery": "0.20% on order value",
      "equityIntraday": "0.02% on order value",
      "equityFutures": "0.02% on order value",
      "equityOptions": "₹20 per order",
      "currencyFutures": "0.02% per order",
      "currencyOptions": "₹20 per order",
      "commodityFutures": "0.02% on order value",
      "commodityOptions": "₹50 per order"
    },
    "margins": {
      "equityDelivery": "4x As per exchange",
      "equityIntraday": "4x As per exchange",
      "equityFutures": "4x As per exchange",
      "equityOptions": "4x As per exchange",
      "currencyFutures": "4x As per exchange",
      "currencyOptions": "4x As per exchange",
      "commodityFutures": "4x As per exchange",
      "commodityOptions": "4x As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": ["Trade Guide Signal", "MO Investor App", "MO Trader App"],
    "pros": [
      "Complimentary analysis and recommendations",
      "Reliable customer support",
      "Thorough research reports",
      "Strategy builder tool",
      "All-in-one platform"
    ],
    "cons": [
      "No flat brokerage plans",
      "Only regular mutual fund plans",
      "Cumbersome offline process",
      "Higher charges"
    ],
    "additionalFeatures": {
      "3in1Account": true,
      "freeTradingCalls": true,
      "freeResearch": true,
      "smsAlerts": true,
      "marginFunding": true,
      "marginAgainstShare": true
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "bonds debt",
      "exchange traded funds",
      "insurance"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "NA", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "Sell-side, ₹ 18.5",
        "gst": "18% on Brokerage + Transaction",
        "stt": "₹ 100 per Lacs",
        "sebiCharges": "₹ 10/Crore"
      },
      "intraday": {
        "transactionCharges": {"BSE": "NA", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "sell side, ₹25 per Lacs",
        "sebiCharges": "₹ 10/Crore"
      },
      "futures": {
        "transactionCharges": {"BSE": "NA", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.02%",
        "sebiCharges": "₹ 10/Crore"
      },
      "options": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.1%",
        "sebiCharges": "₹ 10/Crore"
      }
    },
    "rating": 3.8,
    "features": [
      "Research excellence",
      "Investment advisory",
      "Multiple platforms",
      "Wealth management",
      "Customer support"
    ],
    "equityDelivery": "0.20%",
    "equityIntraday": "0.02%"
  },
  {
    "id": "16",
    "name": "Alice Blue",
    "logo": "https://media.ipoji.com/broker/images/alice-blue-logo.jpeg",
    "type": "Discount Broker",
    "activeClients": "1,26,264",
    "about":
        "Alice Blue is a discount broker that provides trading platforms for various exchanges such as BSE, NSE, and MCX.",
    "accountOpening": "Free",
    "accountMaintenance": 400,
    "callTrade": 20,
    "brokerage": {
      "equityDelivery": "Zero",
      "equityIntraday": "0.01% upto ₹15",
      "equityFutures": "0.01% upto ₹15",
      "equityOptions": "₹15 per order",
      "currencyFutures": "0.01% upto ₹15",
      "currencyOptions": "₹15 per order",
      "commodityFutures": "0.01% upto ₹15",
      "commodityOptions": "₹15 per order"
    },
    "margins": {
      "equityDelivery": "1x As per exchange",
      "equityIntraday": "5x As per exchange",
      "equityFutures": "1x As per exchange",
      "equityOptions": "1x As per exchange",
      "currencyFutures": "1x As per exchange",
      "currencyOptions": "1x As per exchange",
      "commodityFutures": "1x As per exchange",
      "commodityOptions": "1x As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": ["ANT Mobi", "ANT Web", "Trade School"],
    "pros": [
      "Free Equity Delivery in F20 plan",
      "ANT technology platform",
      "NEST Risk Management",
      "Free ANT Trading Software",
      "Third-party tools access"
    ],
    "cons": [
      "No NCDs and corporate bonds",
      "Additional cost for Call & Trade",
      "Site clutter with third-party products"
    ],
    "additionalFeatures": {
      "3in1Account": false,
      "freeTradingCalls": false,
      "freeResearch": true,
      "smsAlerts": false,
      "marginFunding": false,
      "marginAgainstShare": false
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "bonds debt",
      "exchange traded funds"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "NA", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "Sell-side, ₹ 18.5",
        "gst": "18% on Brokerage + Transaction + Demat Charges",
        "stt": "₹ 100 per Lacs",
        "sebiCharges": "₹ 15/Crore"
      },
      "intraday": {
        "transactionCharges": {"BSE": "NA", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "sell side, ₹25 per Lacs",
        "sebiCharges": "₹ 15/Crore"
      },
      "futures": {
        "transactionCharges": {"BSE": "NA", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction + Clearing Charges",
        "stt": "0.02%",
        "sebiCharges": "₹ 15/Crore"
      },
      "options": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction + Clearing Charges",
        "stt": "0.1%",
        "sebiCharges": "₹ 15/Crore"
      }
    },
    "rating": 3.7,
    "features": [
      "Free account opening",
      "Zero delivery charges",
      "Low intraday charges",
      "Trading platform",
      "Customer support"
    ],
    "equityDelivery": "Zero",
    "equityIntraday": "0.01%"
  },
  {
    "id": "17",
    "name": "Anand Rathi",
    "logo": "https://media.ipoji.com/broker/images/anand-rathi-logo.jpeg",
    "type": "Full Service Broker",
    "activeClients": "1,44,643",
    "about":
        "Anand Rathi is a full-service broker that offers broking services along with a range of financial and advisory services.",
    "accountOpening": "Free",
    "accountMaintenance": 450,
    "callTrade": "Free",
    "brokerage": {
      "equityDelivery": "0.20% on order value",
      "equityIntraday": "0.02% on order value",
      "equityFutures": "0.02% on order value",
      "equityOptions": "₹100 per order",
      "currencyFutures": "₹25 per order",
      "currencyOptions": "₹25 per order",
      "commodityFutures": "0.02% on order value",
      "commodityOptions": "₹25 per order"
    },
    "margins": {
      "equityDelivery": "1x As per exchange",
      "equityIntraday": "1x As per exchange",
      "equityFutures": "2x As per exchange",
      "equityOptions": "1x As per exchange",
      "currencyFutures": "1x As per exchange",
      "currencyOptions": "1x As per exchange",
      "commodityFutures": "1x As per exchange",
      "commodityOptions": "1x As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": ["Trade Mobi", "Trade Xpress+", "Trade X'pro", "Trade X'Pro+"],
    "pros": [
      "Online IPO, MF, Bonds, Insurance investment",
      "Free Call & Trade",
      "Complimentary research and trading calls",
      "Loans against shares",
      "NRI account support"
    ],
    "cons": [
      "High non-negotiable brokerage",
      "Additional charges for featured products",
      "No direct mutual fund plans",
      "No access to Trade Xpro & Trade Lite"
    ],
    "additionalFeatures": {
      "3in1Account": true,
      "freeTradingCalls": true,
      "freeResearch": true,
      "smsAlerts": true,
      "marginFunding": true,
      "marginAgainstShare": true
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "bonds debt",
      "exchange traded funds",
      "insurance"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "NA", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "Sell-side, ₹ 18.5",
        "gst": "18% on Brokerage + Transaction + Demat Charges",
        "stt": "₹ 100 per Lacs",
        "sebiCharges": "₹ 15/Crore"
      },
      "intraday": {
        "transactionCharges": {"BSE": "NA", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "sell side, ₹25 per Lacs",
        "sebiCharges": "₹ 15/Crore"
      },
      "futures": {
        "transactionCharges": {"BSE": "NA", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction + Clearing Charges",
        "stt": "0.02%",
        "sebiCharges": "₹ 15/Crore"
      },
      "options": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction + Clearing Charges",
        "stt": "0.1%",
        "sebiCharges": "₹ 15/Crore"
      }
    },
    "rating": 3.6,
    "features": [
      "Established broker",
      "Research services",
      "Investment advisory",
      "Multiple platforms",
      "Wealth management"
    ],
    "equityDelivery": "0.20%",
    "equityIntraday": "0.02%"
  },
  {
    "id": "18",
    "name": "Samco",
    "logo": "https://media.ipoji.com/broker/images/samco-logo.jpeg",
    "type": "Discount Broker",
    "activeClients": "77,584",
    "about":
        "SAMCO is a discount broker that offers trading platforms and investment services for various segments.",
    "accountOpening": "Free",
    "accountMaintenance": 400,
    "callTrade": 20,
    "brokerage": {
      "equityDelivery": "0.50% on order value",
      "equityIntraday": "0.05% on order value",
      "equityFutures": "₹20",
      "equityOptions": "₹20",
      "currencyFutures": "₹20 per order",
      "currencyOptions": "₹20 per order",
      "commodityFutures": "₹20 on order value",
      "commodityOptions": "₹20 per order"
    },
    "margins": {
      "equityDelivery": "4x As per exchange",
      "equityIntraday": "15x As per exchange",
      "equityFutures": "0x As per exchange",
      "equityOptions": "20x As per exchange",
      "currencyFutures": "0x As per exchange",
      "currencyOptions": "0x As per exchange",
      "commodityFutures": "0x As per exchange",
      "commodityOptions": "0x As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": ["Nest Trader", "Rank MF"],
    "pros": [
      "Pledge shares for additional margin",
      "Expert equity research team insights",
      "Caution Watchlist feature",
      "100% brokerage cashback first month"
    ],
    "cons": [
      "Only Regular mutual fund plans",
      "High Pledge/Closure/Invocation charges",
      "Additional call & trade fee",
      "No NRI trading accounts",
      "No free delivery brokerage"
    ],
    "additionalFeatures": {
      "3in1Account": false,
      "freeTradingCalls": false,
      "freeResearch": true,
      "smsAlerts": false,
      "marginFunding": true,
      "marginAgainstShare": true
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "bonds debt",
      "exchange traded funds"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "₹ 1 per Lacs", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "Sell-side, ₹ 18.5",
        "gst": "18% on Brokerage + Transaction + CM Charges",
        "stt": "₹ 100 per Lacs",
        "sebiCharges": "₹ 0.15 per Lacs"
      },
      "intraday": {
        "transactionCharges": {"BSE": "₹ 1 per Lacs", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction + CM Charges",
        "stt": "sell side, ₹25 per Lacs",
        "sebiCharges": "₹ 0.15 per Lacs"
      },
      "futures": {
        "transactionCharges": {"BSE": "₹ 1 per Lacs", "NSE": ""},
        "clearingCharges": {"BSE": "₹ 0.25 per Lacs - BSE", "NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction + CM Charges",
        "stt": "0.02%",
        "sebiCharges": "₹ 0.15 per Lacs"
      },
      "options": {
        "transactionCharges": {"BSE": "₹ 1 per Lacs - BSE", "NSE": ""},
        "clearingCharges": {"BSE": "₹ 0.75 per lacs - BSE", "NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction + CM Charges",
        "stt": "0.1%",
        "sebiCharges": "₹ 0.15 per Lacs"
      }
    },
    "rating": 3.5,
    "features": [
      "Free account opening",
      "Trading platform",
      "Research tools",
      "Mobile trading",
      "Customer support"
    ],
    "equityDelivery": "0.50%",
    "equityIntraday": "0.05%"
  },
  {
    "id": "19",
    "name": "Espresso Sharekhan",
    "logo":
        "https://media.ipoji.com/broker/images/espresso-sharekhan-logo.jpeg",
    "type": "Discount Broker",
    "activeClients": "6,74,378",
    "about":
        "Espresso is a company established by Sharekhan in September 2020, focusing on providing discount broking services.",
    "accountOpening": "Free",
    "accountMaintenance": 400,
    "callTrade": 50,
    "brokerage": {
      "equityDelivery": "Zero",
      "equityIntraday": "0.03% on order value",
      "equityFutures": "0.03%",
      "equityOptions": "₹20",
      "currencyFutures": "0.03% per order",
      "currencyOptions": "₹20 per order",
      "commodityFutures": "0.03% on order value",
      "commodityOptions": "₹20 per order"
    },
    "margins": {
      "equityDelivery": "0x As per exchange",
      "equityIntraday": "4x As per exchange",
      "equityFutures": "0x As per exchange",
      "equityOptions": "0x As per exchange",
      "currencyFutures": "0x As per exchange",
      "currencyOptions": "0x As per exchange",
      "commodityFutures": "0x As per exchange",
      "commodityOptions": "0x As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": [
      "Myespresso Web Trading Platform",
      "Espresso Mobile Application",
      "Binge"
    ],
    "pros": [
      "Pay Only When You Profit feature",
      "Subsidiary of Sharekhan",
      "Educational resources",
      "Free call and trade",
      "FDs as collateral for F&O"
    ],
    "cons": [
      "No banking, insurance, or forex products",
      "No round-the-clock support",
      "No 3-in-1 account"
    ],
    "additionalFeatures": {
      "3in1Account": false,
      "freeTradingCalls": true,
      "freeResearch": false,
      "smsAlerts": false,
      "marginFunding": false,
      "marginAgainstShare": false
    },
    "otherInvestments": ["ipo platform", "exchange traded funds"],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "0.00345%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "Sell-side, ₹ 250 per 100 shares",
        "gst": "18% on Brokerage + Transaction + Exchange Turn over Charges",
        "stt": "0.1% Buy & Sell",
        "sebiCharges": "₹ 10/Crore"
      },
      "intraday": {
        "transactionCharges": {"BSE": "0.00345%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Exchange Turn over Charges",
        "stt": "0.025% Sell-side",
        "sebiCharges": "₹ 10/Crore"
      },
      "futures": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": {"NSE": ""},
        "dpCharge": "--",
        "gst": "18% on Brokerage + Exchange Turn over Charges",
        "stt": "0.02% Sell-side",
        "sebiCharges": "₹ 10/Crore"
      },
      "options": {
        "transactionCharges": {"BSE": "", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Exchange Turn over Charges",
        "stt": "0.1% Sell-side",
        "sebiCharges": "₹ 10/Crore"
      }
    },
    "rating": 3.7,
    "features": [
      "Free account opening",
      "Zero delivery charges",
      "Research services",
      "Trading platform",
      "Investment advisory"
    ],
    "equityDelivery": "Zero",
    "equityIntraday": "0.03%"
  },
  {
    "id": "20",
    "name": "Shoonya",
    "logo": "https://media.ipoji.com/broker/images/shoonya-logo.jpg",
    "type": "Discount Broker",
    "activeClients": "1,52,384",
    "about":
        "Shoonya, created by Finvasia, is a discount stockbroker that revolutionizes trading by offering commission-free trading across all segments.",
    "accountOpening": "Zero",
    "accountMaintenance": "Zero",
    "callTrade": "Zero",
    "brokerage": {
      "equityDelivery": "Zero",
      "equityIntraday": "₹5",
      "equityFutures": "₹5",
      "equityOptions": "₹5",
      "currencyFutures": "₹5",
      "currencyOptions": "₹5",
      "commodityFutures": "₹5",
      "commodityOptions": "₹5"
    },
    "margins": {
      "equityDelivery": "1x As per exchange",
      "equityIntraday": "Upto 5x As per exchange",
      "equityFutures": "1x As per exchange",
      "equityOptions": "1x As per exchange",
      "currencyFutures": "1x As per exchange",
      "currencyOptions": "1x As per exchange",
      "commodityFutures": "1x As per exchange",
      "commodityOptions": "1x As per exchange"
    },
    "services": ["Equity", "Commodity", "Currency", "Futures", "Options"],
    "platforms": [
      "Shoonya Trading Platform",
      "Prism",
      "I Know First - AI Stock Trading"
    ],
    "pros": [
      "Commission-free trading on all segments",
      "No hidden charges",
      "User-friendly platform",
      "Free account opening",
      "Free call and trade",
      "Multiple support channels"
    ],
    "cons": [
      "No 3-in-1 account",
      "Still pay depository charges and taxes",
      "No margin funding",
      "No physical branches"
    ],
    "additionalFeatures": {
      "3in1Account": false,
      "freeTradingCalls": true,
      "freeResearch": false,
      "smsAlerts": false,
      "marginFunding": false,
      "marginAgainstShare": false
    },
    "otherInvestments": [
      "mutual funds",
      "ipo platform",
      "bonds debt",
      "exchange traded funds"
    ],
    "charges": {
      "delivery": {
        "transactionCharges": {"BSE": "0.00375%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharges": "₹9 per scrip (Selling scrip charges)",
        "gst": "18% on Brokerage + Transaction",
        "stt": "0.1% on buy & sell",
        "sebiCharges": "₹ 10/Crore"
      },
      "intraday": {
        "transactionCharges": {"BSE": "0.00375%", "NSE": ""},
        "clearingCharges": "--",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "sell side, 0.025%",
        "sebiCharges": "₹ 10/Crore"
      },
      "futures": {
        "transactionCharges": {"BSE": "0", "NSE": ""},
        "clearingCharges": "",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "sell side, 0.02%",
        "sebiCharges": "₹ 10/Crore"
      },
      "options": {
        "transactionCharges": {"BSE": "0.0325%", "NSE": ""},
        "clearingCharges": "",
        "dpCharge": "--",
        "gst": "18% on Brokerage + Transaction",
        "stt": "sell side, 0.1%",
        "sebiCharges": "₹ 10/Crore"
      }
    },
    "rating": 3.8,
    "features": [
      "Zero account opening",
      "Zero AMC",
      "Zero delivery charges",
      "Low intraday charges",
      "Simple platform"
    ],
    "equityDelivery": "Zero",
    "equityIntraday": "₹5"
  }
];
