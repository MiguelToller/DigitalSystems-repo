const int botao1 = 2;  // Botão 1
const int botao2 = 3;  // Botão 2
const int botao3 = 4;  // Botão 3
const int ledPin = 8;  // LED

void setup() {
  pinMode(botao1, INPUT_PULLUP);
  pinMode(botao2, INPUT_PULLUP);
  pinMode(botao3, INPUT_PULLUP);
  pinMode(ledPin, OUTPUT);
}

void loop() {
  // Lê todos os botões
  bool b1 = digitalRead(botao1) == LOW;
  bool b2 = digitalRead(botao2) == LOW;
  bool b3 = digitalRead(botao3) == LOW;

  // Verifica se os 3 estão pressionados
  if (b1 && b2 && b3) {
    digitalWrite(ledPin, HIGH);  // Liga o LED
  } else {
    digitalWrite(ledPin, LOW);   // Desliga o LED
  }
}
