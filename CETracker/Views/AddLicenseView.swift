//
//  AddLicenseView.swift
//  CETracker
//
//  Created by Jon Onulak on 9/7/22.
//

import SwiftUI

struct AddLicenseView: View {
    @State var licenseInfo = LicenseInfo()
    @State var selectStateTapped = false
    let completionHandler: (LicenseInfo) -> Void

    init(completion: @escaping (LicenseInfo) -> Void) {
        completionHandler = completion
    }

    private var saveButtonDisabled: Bool {
        licenseInfo.state == nil
    }

    var body: some View {
        NavigationView {
            Form {
                Picker(selection: $licenseInfo.state) {
                    if licenseInfo.state == nil { Text("Select").tag(nil as USState?) }
                    ForEach(USState.allCases, id: \.self) { state in
                        Text(state.stateName).tag(state as USState?)
                    }
//                    .navigationTitle("States")
                } label: {
                    Label("State", systemImage: "map")
                }
                .pickerStyle(.menu)
                HStack {
                    Label("License #", systemImage: "number.square")
                    TextField(text: $licenseInfo.licenseNumber) {
                        Text("Optional")
                    }
                    .multilineTextAlignment(.trailing)
                }
                makeDatePicker(selection: $licenseInfo.startDate) {
                    Label("Start Date", systemImage: "calendar")
                }
                makeDatePicker(selection: $licenseInfo.endDate) {
                    Label("End Date", systemImage: "calendar")
                }
                Toggle(isOn: $licenseInfo.isImmunizer) {
                    Label("Immunizer", systemImage: "allergens")
                }
                HStack {
                    Spacer()
                    Button {
                        completionHandler(licenseInfo)
                    } label: {
                        Text("Add")
                    }
                    .disabled(saveButtonDisabled)
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add License")
        }
    }

    private func makeDatePicker<V: View>(selection: Binding<Date>, label: () -> V) -> some View {
        DatePicker(selection: selection, displayedComponents: .date) {
            label()
        }
        .datePickerStyle(.compact)
//        .id(UUID())
    }

}

struct AddLicenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddLicenseView(completion: {_ in

        })
    }
}
