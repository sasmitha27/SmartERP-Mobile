import SwiftUI

struct ContentView: View {
    @AppStorage("smartERP.isSignedIn") private var isSignedIn = false
    var body: some View {
        Group { if isSignedIn { MainTabView() } else { SignInView(isSignedIn: $isSignedIn) } }
            .tint(ERPTheme.blue)
    }
}

private enum ERPTheme {
    static let navy = Color(red: 14/255, green: 46/255, blue: 89/255)
    static let blue = Color(red: 10/255, green: 133/255, blue: 1)
    static let paleBlue = Color(red: 227/255, green: 242/255, blue: 1)
    static let ink = Color(red: 18/255, green: 23/255, blue: 38/255)
    static let muted = Color(red: 107/255, green: 115/255, blue: 130/255)
}

private struct SignInView: View {
    @Binding var isSignedIn: Bool
    @State private var email = "warehouse@company.lk"
    @State private var password = "warehouse"
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 64)
            Text("SmartERP").font(.system(size: 34, weight: .bold)).foregroundStyle(ERPTheme.navy)
            Text("Mobile warehouse operations").font(.subheadline).foregroundStyle(ERPTheme.muted).padding(.top, 4)
            VStack(alignment: .leading, spacing: 12) {
                Text("Receive stock faster.").font(.title3.bold()).foregroundStyle(ERPTheme.navy)
                Text("Scan products, verify purchase orders and create accurate GRNs directly from your iPhone.").font(.subheadline).foregroundStyle(ERPTheme.muted)
            }.padding(18).frame(maxWidth: .infinity, alignment: .leading).background(ERPTheme.paleBlue, in: .rect(cornerRadius: 22)).padding(.top, 38)
            VStack(alignment: .leading, spacing: 8) {
                FieldLabel("Email"); TextField("Email", text: $email).textInputAutocapitalization(.never).keyboardType(.emailAddress).erpField()
                FieldLabel("Password").padding(.top, 8); SecureField("Password", text: $password).erpField()
            }.padding(.top, 48)
            Button("Sign In") { isSignedIn = true }.buttonStyle(PrimaryButtonStyle()).padding(.top, 38)
            Text("Face ID available after first sign in").font(.caption).foregroundStyle(ERPTheme.muted).frame(maxWidth: .infinity).padding(.top, 18)
            Spacer()
        }.padding(.horizontal, 24).background(Color(.systemBackground))
    }
}

private struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack { PurchaseOrdersView() }.tabItem { Label("Orders", systemImage: "list.bullet.rectangle") }
            NavigationStack { ReceivingDashboardView() }.tabItem { Label("Receive", systemImage: "plus.circle.fill") }
            NavigationStack { InventoryView() }.tabItem { Label("Inventory", systemImage: "magnifyingglass") }
            NavigationStack { HistoryView() }.tabItem { Label("History", systemImage: "clock.arrow.circlepath") }
            NavigationStack { VisitsView() }.tabItem { Label("Visits", systemImage: "mappin.and.ellipse") }
        }
    }
}

private struct ReceivingDashboardView: View {
    var body: some View {
        ScrollView { VStack(alignment: .leading, spacing: 16) {
            Text("Good morning, Sasmitha").foregroundStyle(ERPTheme.muted)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) { MetricCard(title: "Pending POs", value: "6", color: .orange); MetricCard(title: "Draft GRNs", value: "2", color: ERPTheme.blue); MetricCard(title: "Low Stock", value: "8", color: .red); MetricCard(title: "Received Today", value: "14", color: .green) }
            SectionTitle("Quick actions")
            NavigationLink { ScannerView() } label: { Text("Start Goods Receiving") }.buttonStyle(PrimaryButtonStyle())
            HStack(spacing: 14) { NavigationLink { PurchaseOrdersView() } label: { ActionCard(title: "Purchase Orders", subtitle: "6 pending", icon: "doc.text") }; NavigationLink { InventoryView() } label: { ActionCard(title: "Inventory Search", subtitle: "8 low stock", icon: "magnifyingglass") } }
            SectionTitle("Recent activity")
            ActivityCard(title: "GRN #GRN-1048", subtitle: "Sunrise Suppliers · 12 items", badge: "Completed", color: .green)
            ActivityCard(title: "PO #PO-1284", subtitle: "Techline Distributors · due today", badge: "Pending", color: .orange)
        }.padding(24) }.navigationTitle("Receiving").navigationBarTitleDisplayMode(.large)
    }
}

private struct PurchaseOrdersView: View {
    @State private var search = ""
    private let orders = [PurchaseOrder(number: "PO-1284", supplier: "Techline Distributors", lines: 5, status: "Due today"), PurchaseOrder(number: "PO-1281", supplier: "Greenfield Trading", lines: 8, status: "28 Sep"), PurchaseOrder(number: "PO-1279", supplier: "Metro Supplies", lines: 3, status: "Partial"), PurchaseOrder(number: "PO-1274", supplier: "Lanka Packaging", lines: 12, status: "30 Sep")]
    var body: some View {
        List { Section { Text("6 orders awaiting receiving").foregroundStyle(ERPTheme.muted).listRowBackground(Color.clear).listRowSeparator(.hidden) }; Section { Picker("Status", selection: .constant("Pending")) { Text("Pending").tag("Pending"); Text("Partial").tag("Partial"); Text("Completed").tag("Completed") }.pickerStyle(.segmented).listRowBackground(Color.clear).listRowSeparator(.hidden) }; Section { ForEach(orders.filter { search.isEmpty || $0.number.localizedCaseInsensitiveContains(search) || $0.supplier.localizedCaseInsensitiveContains(search) }) { order in NavigationLink { PurchaseOrderDetailView(order: order) } label: { OrderRow(order: order) } } } }.listStyle(.plain).navigationTitle("Purchase Orders").searchable(text: $search, prompt: "Search purchase orders")
    }
}

private struct PurchaseOrderDetailView: View {
    let order: PurchaseOrder
    private let products = [("Wireless Mouse", "SKU WM-200 · Barcode 4791002001", "10"), ("USB-C Hub", "SKU HUB-7 · Barcode 4791002028", "6"), ("Keyboard K2", "SKU KB-K2 · Barcode 4791002073", "8")]
    var body: some View {
        ScrollView { VStack(alignment: .leading, spacing: 16) {
            Text(order.supplier).foregroundStyle(ERPTheme.muted); HStack { StatusPill("Pending", color: .orange); Text("Expected 27 Sep 2026").font(.subheadline).foregroundStyle(ERPTheme.muted) }
            SectionTitle("Order summary")
            HStack { SummaryStat("Ordered", "24"); Divider(); SummaryStat("Received", "0"); Divider(); SummaryStat("Outstanding", "24") }.padding().background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 16))
            SectionTitle("Products"); ForEach(products, id: \.0) { ProductRow(name: $0.0, detail: $0.1, quantity: $0.2) }
            NavigationLink { ScannerView() } label: { Text("Receive This Order") }.buttonStyle(PrimaryButtonStyle()).padding(.top, 12)
        }.padding(24) }.navigationTitle(order.number).navigationBarTitleDisplayMode(.large)
    }
}

private struct ScannerView: View {
    @State private var isScanning = true; @State private var received = 0
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("PO-1284 · \(received) of 24 received").foregroundStyle(ERPTheme.muted)
            ZStack { LinearGradient(colors: [Color(red: 0.08, green: 0.13, blue: 0.18), Color(red: 0.25, green: 0.34, blue: 0.42)], startPoint: .top, endPoint: .bottom); VStack(spacing: 20) { Text(isScanning ? "LIVE CAMERA" : "BARCODE DETECTED").font(.caption.bold()).foregroundStyle(.white.opacity(0.75)); RoundedRectangle(cornerRadius: 12).stroke(ERPTheme.blue, lineWidth: 4).frame(width: 260, height: 170); Text(isScanning ? "Align barcode inside the frame" : "4791002001 · Wireless Mouse").foregroundStyle(.white).font(.headline) } }.frame(height: 395).clipShape(.rect(cornerRadius: 18))
            Text("Vision detects supported barcodes on-device.").font(.footnote).foregroundStyle(ERPTheme.muted)
            VStack(alignment: .leading, spacing: 8) { Text("Receiving progress").font(.subheadline); Text("\(received) / 24 items").font(.title3.bold()); ProgressView(value: Double(received), total: 24).tint(ERPTheme.blue) }.padding().background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 16))
            Button(isScanning ? "Simulate Scan" : "Receive Item") { if isScanning { isScanning = false } else { received += 1; isScanning = true } }.buttonStyle(PrimaryButtonStyle()); Button("Manual entry") {}.frame(maxWidth: .infinity); Spacer()
        }.padding(24).navigationTitle("Scan Products").navigationBarTitleDisplayMode(.large)
    }
}

private struct InventoryView: View {
    @State private var search = ""; let products = [("Wireless Mouse", "WM-200", "18", "In stock"), ("USB-C Hub", "HUB-7", "4", "Low stock"), ("Keyboard K2", "KB-K2", "0", "Out of stock")]
    var body: some View { List { ForEach(products.filter { search.isEmpty || $0.0.localizedCaseInsensitiveContains(search) }, id: \.0) { product in NavigationLink { ProductDetailView(name: product.0, sku: product.1, quantity: product.2, state: product.3) } label: { ProductRow(name: product.0, detail: "SKU \(product.1)", quantity: product.2) } } }.navigationTitle("Inventory").searchable(text: $search, prompt: "Search inventory").toolbar { ToolbarItem(placement: .topBarTrailing) { NavigationLink { ProductFormView() } label: { Image(systemName: "plus") } } } }
}
private struct ProductDetailView: View { let name: String; let sku: String; let quantity: String; let state: String; var body: some View { Form { Section("Stock") { LabeledContent("Available", value: "\(quantity) pcs"); LabeledContent("Status", value: state); LabeledContent("SKU", value: sku) }; Section { NavigationLink("Adjust stock") { Text("Stock adjustments are ready to be connected to your backend.") } } }.navigationTitle(name).navigationBarTitleDisplayMode(.inline) } }
private struct ProductFormView: View { @Environment(\.dismiss) private var dismiss; @State private var name = ""; @State private var sku = ""; @State private var barcode = ""; @State private var category = "General"; @State private var quantity = "0"; var body: some View { Form { Section("Product details") { TextField("Product name", text: $name); TextField("SKU / Product Code", text: $sku); TextField("Barcode", text: $barcode); Picker("Category", selection: $category) { Text("General").tag("General"); Text("Electronics").tag("Electronics") } }; Section("Opening stock") { TextField("Quantity", text: $quantity).keyboardType(.numberPad) } }.navigationTitle("New Inventory Product").toolbar { ToolbarItem(placement: .confirmationAction) { Button { dismiss() } label: { Image(systemName: "checkmark") }.disabled(name.isEmpty || sku.isEmpty) } } } }
private struct HistoryView: View { var body: some View { List { ActivityCard(title: "GRN #GRN-1048", subtitle: "Sunrise Suppliers · 12 items", badge: "Completed", color: .green); ActivityCard(title: "GRN #GRN-1047", subtitle: "Metro Supplies · 4 items", badge: "Completed", color: .green) }.navigationTitle("History") } }
private struct VisitsView: View { var body: some View { ContentUnavailableView("No visits scheduled", systemImage: "mappin.and.ellipse", description: Text("Supplier delivery visits will appear here.")).navigationTitle("Visits") } }
private struct PurchaseOrder: Identifiable { let number: String; let supplier: String; let lines: Int; let status: String; var id: String { number } }
private struct FieldLabel: View { let value: String; init(_ value: String) { self.value = value }; var body: some View { Text(value).font(.caption.bold()).foregroundStyle(ERPTheme.muted) } }
private struct SectionTitle: View { let value: String; init(_ value: String) { self.value = value }; var body: some View { Text(value.uppercased()).font(.caption.bold()).foregroundStyle(ERPTheme.muted).padding(.top, 4) } }
private struct MetricCard: View { let title: String; let value: String; let color: Color; var body: some View { VStack(alignment: .leading) { Text(title).font(.caption).foregroundStyle(ERPTheme.muted); Text(value).font(.system(size: 32, weight: .bold)).foregroundStyle(ERPTheme.ink); Spacer(); Circle().fill(color).frame(width: 8, height: 8) }.padding(14).frame(height: 108).frame(maxWidth: .infinity, alignment: .leading).background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 16)) } }
private struct ActionCard: View { let title: String; let subtitle: String; let icon: String; var body: some View { VStack(alignment: .leading, spacing: 10) { Image(systemName: icon).foregroundStyle(ERPTheme.blue); Text(title).font(.subheadline.weight(.semibold)).foregroundStyle(ERPTheme.ink); Text(subtitle).font(.caption).foregroundStyle(ERPTheme.muted) }.padding(16).frame(maxWidth: .infinity, minHeight: 100, alignment: .leading).background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 16)) } }
private struct ActivityCard: View { let title: String; let subtitle: String; let badge: String; let color: Color; var body: some View { HStack { Rectangle().fill(color).frame(width: 5); VStack(alignment: .leading, spacing: 5) { Text(title).font(.subheadline.weight(.semibold)); Text(subtitle).font(.caption).foregroundStyle(ERPTheme.muted) }; Spacer(); StatusPill(badge, color: color) }.padding(.vertical, 12).padding(.trailing, 12).background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 14)) } }
private struct StatusPill: View { let value: String; let color: Color; init(_ value: String, color: Color) { self.value = value; self.color = color }; var body: some View { Text(value).font(.caption.weight(.semibold)).foregroundStyle(color).padding(.horizontal, 8).padding(.vertical, 5).background(color.opacity(0.13), in: .capsule) } }
private struct OrderRow: View { let order: PurchaseOrder; var body: some View { HStack { Rectangle().fill(order.status == "Due today" ? Color.orange : ERPTheme.blue).frame(width: 5); VStack(alignment: .leading, spacing: 5) { Text(order.number).font(.headline); Text("\(order.supplier) · \(order.lines) lines").font(.caption).foregroundStyle(ERPTheme.muted) }; Spacer(); Text(order.status).font(.caption).foregroundStyle(order.status == "Due today" ? .orange : ERPTheme.muted) }.padding(.vertical, 8) } }
private struct ProductRow: View { let name: String; let detail: String; let quantity: String; var body: some View { HStack { VStack(alignment: .leading, spacing: 5) { Text(name).font(.subheadline.weight(.semibold)); Text(detail).font(.caption).foregroundStyle(ERPTheme.muted) }; Spacer(); Text(quantity).font(.headline).foregroundStyle(ERPTheme.navy) }.padding().background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 14)) } }
private struct SummaryStat: View { let label: String; let value: String; init(_ label: String, _ value: String) { self.label = label; self.value = value }; var body: some View { VStack(alignment: .leading) { Text(label).font(.caption).foregroundStyle(ERPTheme.muted); Text(value).font(.title2.bold()) }.frame(maxWidth: .infinity, alignment: .leading) } }
private struct PrimaryButtonStyle: ButtonStyle { func makeBody(configuration: Configuration) -> some View { configuration.label.font(.headline).foregroundStyle(.white).frame(maxWidth: .infinity).frame(height: 52).background(ERPTheme.blue.opacity(configuration.isPressed ? 0.75 : 1), in: .rect(cornerRadius: 14)) } }
private extension View { func erpField() -> some View { self.padding(.horizontal, 14).frame(height: 50).background(Color(.systemBackground), in: .rect(cornerRadius: 12)).overlay { RoundedRectangle(cornerRadius: 12).stroke(Color(red: 219/255, green: 222/255, blue: 229/255)) } } }

#Preview { ContentView() }
