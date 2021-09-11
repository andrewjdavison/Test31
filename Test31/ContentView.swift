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
    @Binding var licence: Licence
    @Binding var showModal: Bool
    
    @State var selectedElement: Element

    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Element.desc, ascending: true)],
        animation: .default)
    private var elements: FetchedResults<Element>
    
    
    init(currentLicence: Binding<Licence>, showModal: Binding<Bool>, context: NSManagedObjectContext) {
        self._licence = currentLicence
        self._showModal = showModal
        
        _selectedElement = State(initialValue: currentLicence.wrappedValue.licenced!)
    }
        
    func save() {
        licence.licenced = selectedElement
        try! viewContext.save()
        showModal = false
        
    }
    
    var body: some View {
        VStack {
            Button(action: {showModal = false}) {
                Text("Close")
            }
            Picker(selection: $selectedElement, label: Text("Element")) {
                ForEach(elements, id: \.self) { element in
                    Text("\(element.desc!)")
                }
            }
            Text("Selected: \(selectedElement.desc!)")
            Button(action: {save()}) {
                Text("Save")
            }
        }
        
    }
}

struct RegisterView : View {
    @Environment(\.managedObjectContext) private var viewContext

    @State var showModal: Bool = false
    var register: Register
    
    @State var currentLicence: Licence
    
    @State var id : UUID = UUID()
    
    init(currentRegister: Register) {
        self.register = currentRegister
        _currentLicence = State(initialValue: Array(currentRegister.licencedUsers! as! Set<Licence>)[0])

    }
    
    func viewDismissed() {
        id = UUID()
    }
    
    var body: some View {
        VStack {
            List {
                ForEach (Array(register.licencedUsers! as! Set<Licence>)
                            .sorted(by: {$0.leasee! < $1.leasee!}), id: \.self) { licence in
                    Button(action: {currentLicence = licence; showModal = true}) {
                        HStack {
                            Text("\(licence.leasee!) : ")
                            Text("\(licence.licenced!.desc!)")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showModal, onDismiss: viewDismissed) {
            LicenceView(currentLicence: $currentLicence, showModal: $showModal, context: viewContext )
        }.id(id)
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
                        NavigationLink(destination: RegisterView(currentRegister: register)) {
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
