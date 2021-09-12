//
//  ContentView.swift
//  Test31
//
//  Created by Andrew Davison on 9/9/21.
//

import SwiftUI
import CoreData


struct LicenceView : View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    
    @ObservedObject var licence: Licence
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Element.desc, ascending: true)],
        animation: .default)
    private var elements: FetchedResults<Element>
    
    func save() {
        try! viewContext.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            Button(action: {presentationMode.wrappedValue.dismiss()}) {
                Text("Close")
            }
            Picker(selection: $licence.licenced, label: Text("Element")) {
                ForEach(elements, id: \.self) { element in
                    Text("\(element.desc!)")
                        .tag(element as Element?)
                }
            }
            Text("Selected: \(licence.licenced!.desc!)")
            Button(action: {save()}) {
                Text("Save")
            }
        }
    }
}

struct RegisterView : View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var register: Register
    @State var currentLicence : Licence?
    
    var body: some View {
        VStack {
            List {
                ForEach (Array(register.licencedUsers! as! Set<Licence>)
                            .sorted(by: {$0.leasee! < $1.leasee!}), id: \.self) { licence in
                    Button(action: {currentLicence = licence}) {
                        HStack {
                            Text("\(licence.leasee!) : ")
                            Text("\(licence.licenced!.desc!)")
                        }
                    }
                }
            }
        }
        .sheet(item: $currentLicence) { item  in
            LicenceView(licence: item)
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Register.id, ascending: true)],
        animation: .default)
    private var registers: FetchedResults<Register>

    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(registers) { register in
                        NavigationLink(destination: RegisterView(register: register)) {
                            Text("Register id \(register.id!)")
                        }
                    }
                }
            }
            Button(action: { PersistenceController.shared.initData()}) {
                Text("Init Data")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
