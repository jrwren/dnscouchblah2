//
//  blah2App.swift
//  blah2
//
//  Created by Jay Wren on 10/30/23.
//

import SwiftUI

@main
struct blah2App: App {
    var results:[Result] = .init()
    init() {
        // Do DNS lookup here, now, once, for now.
        var id = 0
        for (ip,desc) in serverMap {
            let res = Result(id:id, name: ip, description: desc, duration:Duration.zero)
            let lu = LookerUpper(res:res)
            lu.timeDNSLookup(server: ip)
            id += 1
            self.results.append(res)
        }
    }
    var body: some Scene {
        WindowGroup {
            ResultList(results:results)
        }
    }
}

var serverMap = [
    "1.1.1.1": "Cloudflare One",
    "1.0.0.1": "Cloudflare One",
    "8.8.8.8": "Google Primary",
    "8.8.4.4": "Google Secondary",
    // TODO: ipv6
    //      "[2001:4860:4860::8888]:53": "Google Primary",
    //      "[2001:4860:4860::8844]:53": "Google Secondary",
    "208.67.222.222": "OpenDNS Primary",
    "208.67.220.220": "OpenDNS Secondary",
    "4.2.2.1":        "Level 3",
    "209.244.0.3":    "Level 3",
    "209.244.0.4":    "Level 3",
    "9.9.9.10":       "Quad9 unfiltered",
    "149.112.112.10": "Quad9 unfiltered",
    "68.94.156.1":    "ATT Primary",
    "68.94.157.1":    "ATT Secondary",
    "12.121.117.201": "ATT Services",
    "8.26.56.26":     "Comodo Primary",
    "8.20.247.20":    "Comodo Secondary",
    "76.76.2.0":      "Control D Primary",
    "76.76.10.0":     "Control D Secondary",
    "185.228.168.9":  "Clean Browsing Primary",
    "185.228.169.9":  "Clean Browsing Secondary",
    "76.76.19.19":    "Alternate DNS Primary",
    "76.223.122.150": "Alternate DNS Secondary",
    "94.140.14.14":   "AdGuard DNS Primary",
    "94.140.15.15":   "AdGuard DNS Secondary",
]

let filteredServerMap = [
        "1.1.1.2":         "Cloudflare Malware Filtered",
        "1.0.0.2":         "Cloudflare Malware Filtered",
        "1.1.1.3":         "Cloudflare Adult Filtered",
        "1.0.0.3":         "Cloudflare Adult Filtered",
        "9.9.9.9":         "Quad9 filtered Primary",
        "149.112.112.112": "Quad9 filtered Secondary",
        // Not technically a filter, but a strange, rare feature:
        // EDNS Client-Subnet.
        // More about ECS here: https://www.isc.org/blogs/quad9-2020-06/ and
        // here: https://www.quad9.net/support/faq/#edns
        "9.9.9.11":       "Quad9 ecs unfiltered",
        "149.112.112.11": "Quad9 ecs unfiltered",
]

// TODO: addSystemResolvers reads /etc/resolv.conf (or system api) and adds nameservers to serverMap.
// TODO: addComcast to add Comcast servers. They don't respond outside of the Comcast network.
