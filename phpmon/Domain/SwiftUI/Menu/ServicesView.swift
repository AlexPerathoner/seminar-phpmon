//
//  ServicesView.swift
//  PHP Monitor
//
//  Created by Nico Verbruggen on 10/06/2022.
//  Copyright © 2022 Nico Verbruggen. All rights reserved.
//

import Foundation
import SwiftUI

struct ServicesView: View {

    static func asMenuItem(perRow: Int = 4) -> NSMenuItem {
        let item = NSMenuItem()

        let manager = ServicesManager.shared

        let rootView = Self(
            manager: manager,
            perRow: perRow
        )

        let view = NSHostingView(rootView: rootView)
        view.autoresizingMask = [.width]
        view.setFrameSize(
            CGSize(width: view.frame.width, height: rootView.height + 30)
        )
        // view.layer?.backgroundColor = CGColor.init(red: 255, green: 0, blue: 0, alpha: 1)
        view.focusRingType = .none

        item.view = view
        return item
    }

    @ObservedObject var manager: ServicesManager
    var perRow: Int
    var rowCount: Int
    var rowSpacing: Int = 5
    var rowHeight: Int = 30
    var statusHeight: Int = 30
    var height: CGFloat

    init(manager: ServicesManager, perRow: Int) {
        self.manager = manager
        self.perRow = perRow
        self.rowCount = manager.serviceWrappers.chunked(by: perRow).count
        self.height = CGFloat(
            (rowHeight * rowCount)
            + ((rowCount - 1) * rowSpacing)
            + statusHeight
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: CGFloat(self.rowSpacing)) {
                ForEach(manager.serviceWrappers.chunked(by: perRow), id: \.self) { chunk in
                    HStack {
                        ForEach(chunk) { service in
                            ServiceView(service: service)
                                .frame(minWidth: 70)
                        }
                    }
                    .frame(height: CGFloat(self.rowHeight))
                    .padding(CGFloat(self.rowSpacing))
                }
            }
            .frame(height: self.height)
            .frame(maxWidth: .infinity, alignment: .center)
            // .background(Color.red)

            VStack(alignment: .center) {
                HStack {
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundColor(self.manager.statusColor)
                    Text(self.manager.statusMessage)
                        .font(.system(size: 12))
                }
            }
            .frame(height: CGFloat(self.statusHeight))
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct ServiceView: View {
    @ObservedObject var service: ServiceWrapper

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(service.name.uppercased())
                .font(.system(size: 10))
                .frame(minWidth: 70, alignment: .center)
                .padding(.top, 4)
                .padding(.bottom, 2)
            if service.status == .loading {
                ProgressView()
                    .scaleEffect(x: 0.4, y: 0.4, anchor: .center)
                    .frame(minWidth: 70, alignment: .center)
                    .frame(width: 25, height: 25)
            }
            if service.status == .missing {
                Button {
                    Task { @MainActor in
                        BetterAlert().withInformation(
                            title: "alert.warnings.service_missing.title".localized,
                            subtitle: "alert.warnings.service_missing.subtitle".localized,
                            description: "alert.warnings.service_missing.description".localized
                        )
                        .withPrimary(text: "OK")
                        .show()
                    }
                } label: {
                    Text("?")
                }
                .focusable(false)
                // .buttonStyle(BlueButton())
                .frame(minWidth: 70, alignment: .center)
            }
            if service.status == .active || service.status == .inactive {
                Button {
                    Task { await ServicesManager.shared.toggleService(named: service.name) }
                } label: {
                    Image(
                        systemName: service.status == .active ? "checkmark" : "xmark"
                    )
                    .resizable()
                    .frame(width: 12.0, height: 12.0)
                    .foregroundColor(
                        service.status == .active ? Color("IconColorGreen") : Color("IconColorRed")
                    )
                }.frame(width: 25, height: 25)
            }
        }.frame(minWidth: 70)
    }
}

public struct BlueButton: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 25, height: 25)
            .background(configuration.isPressed
                ? Color(red: 0, green: 0.5, blue: 0.9)
                : Color(red: 0, green: 0, blue: 0.5)
            )
            .foregroundColor(.white)
            .clipShape(Capsule())
            .contentShape(Rectangle())
    }
}

struct ServicesView_Previews: PreviewProvider {
    static var previews: some View {
        ServicesView(manager: FakeServicesManager(
            formulae: ["php", "nginx", "dnsmasq"],
            status: .loading
        ), perRow: 4)
        .frame(width: 330.0)
        .previewDisplayName("Loading")

        ServicesView(manager: FakeServicesManager(
            formulae: ["php", "nginx", "dnsmasq"],
            status: .active
        ), perRow: 4)
        .frame(width: 330.0)
        .previewDisplayName("Active 1")

        ServicesView(manager: FakeServicesManager(
            formulae: [
                "php", "nginx", "dnsmasq", "thing1",
                "thing2", "thing3", "thing4", "thing5"
            ],
            status: .active
        ), perRow: 4)
        .frame(width: 330.0)
        .previewDisplayName("Active 2")
    }
}
