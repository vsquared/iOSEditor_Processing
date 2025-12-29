class RunButton extends JPanel {
  int radius = 13; // Size of Btn
  // Coordinates for runBtn triangle
  int x[] = {16, 16, 18};
  int y[] = {16, 18, 17};

  RunButton() {
    setOpaque(false);   
  }

  void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D)g;
    super.paintComponent(g);
    BasicStroke bs = new BasicStroke(8.0);
    g2.setStroke(bs);
    g2.setColor (Color.lightGray);
    g2.drawOval(getWidth()/2 - radius, getHeight()/2 - radius, radius * 2, radius * 2);
    g2.setColor (new Color(24, 70, 183));
    g2.fillOval(getWidth()/2 - radius, getHeight()/2 - radius, radius * 2, radius * 2);
    g2.setColor(Color.white);
    g2.drawPolygon(x, y, 3);
  }
}
RunButton runBtn;
