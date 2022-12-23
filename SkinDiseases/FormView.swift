//
//  FormView.swift
//  SkinDiseases
//
//  Created by Ankita Chatterjee on 4/16/22.


import SwiftUI

struct FormView: View {
    @State var firstName=""
    @State var lastName=""
    @State var patientEmail=""
    @State var doctorEmail=""
    @State var clinicCode=""
    @State var canNotify=false
    var body: some View {
        Form {
            TextField("First Name",text:$firstName)
                .onChange(of: firstName) { newValue in
                    print("Updated first name  to \(newValue)")
                }
            TextField("Last Name",text:$lastName)
                .onChange(of: lastName) { newValue in
                    print("Updated last name  to \(newValue)")
                }
            TextField("Patient Email",text:$patientEmail)
                .onChange(of: patientEmail) { newValue in
                    print("Updated patient email  to \(newValue)")
                }
            TextField("Doctor Email",text:$doctorEmail)
                .onChange(of: doctorEmail) { newValue in
                    print("Updated doctor email  to \(newValue)")
                }
            TextField("Clinic Code",text:$clinicCode)
                .onChange(of: clinicCode) { newValue in
                    print("Updated clinic code  to \(newValue)")
                }
            Toggle(isOn: $canNotify) {
                Text("Notification")
            }.onChange(of: canNotify) { newValue in
                print("Updated canNotify to \(newValue)")
            }
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}













