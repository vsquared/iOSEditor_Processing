class QuitButton extends JPanel {
  int radius = 13; // Size of Btn

  QuitButton() {
    setOpaque(false); 
  }

  void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D)g;
    super.paintComponent(g);
    BasicStroke bs = new BasicStroke(8.0);
    Font myFont = new Font("Menlo",Font.BOLD,22);
    g2.setStroke(bs);
    g2.setColor(Color.lightGray);
    g2.drawOval(getWidth()/2 - radius, getHeight()/2 - radius, radius * 2, radius * 2);
    g2.setColor(new Color(66,66,66));
    g2.fillOval(getWidth()/2 - radius, getHeight()/2 - radius, radius * 2, radius * 2);
    g2.setColor(Color.white);
    g2.setFont(myFont);
    g2.drawString("Q",11,25);
  }
}
QuitButton quitBtn;
