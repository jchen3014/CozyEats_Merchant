import SwiftUI

class OrderCounter: ObservableObject {
    @Published var ordersMade: Int = 0
}

struct PaymentView: View {
    @State private var nameOnCard = ""
    @State private var cardNumber = ""
    @State private var securityCode = ""
    @State private var expirationMonth = ""
    @State private var expirationYear = ""
    @State private var isOrderConfirmed = false
    @ObservedObject private var orderCounter = OrderCounter()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Select Payment Option")
            HStack {
                Button(action: {
                    // Add action for credit card
                    print("Credit Card Clicked")
                }) {
                    Image("credit")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(.blue)
                        .padding(.trailing, 20)
                }

                Button(action: {
                    // Add action for Apple Pay
                    print("Apple Pay Clicked")
                }) {
                    Image("apple_pay")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(.blue)
                        .padding(.trailing, 20)
                }

                Button(action: {
                    // Add action for Google Pay
                    print("Google Pay Clicked")
                }) {
                    Image("g_pay")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(.blue)
                        .padding(.trailing, 20)
                }

                Button(action: {
                    // Add action for Venmo
                    print("Venmo Clicked")
                }) {
                    Image("venmo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(.blue)
                        .padding(.trailing, 20)
                }

                Button(action: {
                    // Add action for PayPal
                    print("PayPal Clicked")
                }) {
                    Image("paypal")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(.blue)
                        .padding(.trailing, 20)
                }
            }

            Text("Name on Card:")
            TextField("Enter name on card", text: $nameOnCard)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("Card Number:")

            TextField("Enter card number", text: $cardNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .onReceive(cardNumber.publisher.collect()) { digits in
                    let filteredDigits = digits.filter(\.isWholeNumber)
                    cardNumber = String(filteredDigits.prefix(16))
                }
                .frame(maxWidth: .infinity)


            HStack {
                Text("Security Code:")
                    .frame(width: 120, alignment: .leading)
                
                TextField("Enter security code", text: $securityCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onReceive(securityCode.publisher.collect()) { digits in
                        let filteredDigits = digits.filter(\.isWholeNumber)
                        securityCode = String(filteredDigits.prefix(4))
                    }
                    .frame(width: 175)
            }

            HStack {
                Text("Exp. Month:")
                
                TextField("MM", text: $expirationMonth)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onReceive(expirationMonth.publisher.collect()) { digits in
                        let filteredDigits = digits.filter(\.isWholeNumber)
                        if let monthValue = Int(String(filteredDigits.prefix(2))), (1...12).contains(monthValue) {
                            expirationMonth = String(monthValue)
                        } else {
                            expirationMonth = ""
                        }
                    }
                    .frame(width: 50)

                Text("Exp. Year:")
                
                TextField("YY", text: $expirationYear)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onReceive(expirationYear.publisher.collect()) { digits in
                        let filteredDigits = digits.filter(\.isWholeNumber)
                        expirationYear = String(filteredDigits.prefix(2))
                    }
                    .frame(width: 50)
            }
            Spacer()
            HStack {
                                Spacer()
                                Button(action: {
                                    isOrderConfirmed = true
                                    orderCounter.ordersMade += 1
                                }) {
                                    Text("Confirm Order")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.green)
                                        .cornerRadius(10)
                                        .font(.headline)
                                }
                                Spacer()
                            }
                            .fullScreenCover(isPresented: $isOrderConfirmed) {
                                Text("Order Confirmed!")
                                
                            }
                            Spacer()
        }
        .padding(20)
        .navigationBarTitle("Payment", displayMode: .inline)
    }
}



#Preview {
    PaymentView()
}

