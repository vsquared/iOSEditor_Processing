import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;

import com.dd.plist.*;
import org.fife.ui.rsyntaxtextarea.*;
import org.fife.ui.rtextarea.*;

import java.io.*;
import java.io.File;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import javax.swing.text.BadLocationException;
import static java.awt.event.InputEvent.META_DOWN_MASK;

import java.awt.event.MouseEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseListener;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

JFrame frame;
JScrollPane txtScrlPane;
RSyntaxTextArea txtArea;
JTextArea logArea;
JSplitPane splitPane;
JScrollPane logScrlPane;
JToolBar toolbar;
JButton openBtn;
JButton fileBtn;
JPopupMenu pupMenu;
JComboBox simsComboBox;

File file;

final int _wndW = 850;
final int _wndH = 700;

// *** Folder to Open. Change for your system **** //
String folderStr = "/Users/xxxx/Desktop/ios_java";

String filePath = "";
String filePathNoExt = "";
String appName = "";
String uuid = "";

String removeExtension(String filePath) {
  int dotIndx = filePath.lastIndexOf('.');
  if (dotIndx != -1) {
    return filePath.substring(0, dotIndx);
  } else {
    return filePath;
  }
}

void openAction() {
  JFileChooser fileChooser = new JFileChooser(folderStr);
  int i = fileChooser.showOpenDialog(fileChooser);
  if (i == JFileChooser.APPROVE_OPTION) {
    file = fileChooser.getSelectedFile();
    filePath = file.getPath();
    filePathNoExt = removeExtension(filePath);
    logArea.append("filePath: " +filePath + "\n");
    frame.setTitle(filePath);
    String lastComponent = file.getName();
    appName = removeExtension(lastComponent);
    logArea.append("appName: " + appName + "\n");
    try {
      BufferedReader buffer = new BufferedReader(new FileReader(filePath));
      String s = "", s1 = "";
      while ((s = buffer.readLine())!= null) {
        s1 += s + "\n";
      }
      txtArea.setText(s1);
      buffer.close();
    }
    catch (Exception ex) {
      logArea.append(ex + "\n");
    }
  } else {
    logArea.append("Open cancelled.");
  }
}

void saveAction() {
  if (filePath != null) {
    try {
      String content = txtArea.getText();
      FileWriter fw = new FileWriter(filePath) ;
      BufferedWriter bw = new BufferedWriter(fw);
      bw.write(content);
      bw.close();
    }
    catch (IOException e) {
      logArea.append(e + "\n");
    }
  } else {
    saveAsAction();
  }
}

void saveAsAction() {
  JFileChooser fileChooser = new JFileChooser(folderStr);
  fileChooser.setSelectedFile(new File("untitled.swift"));
  int option = fileChooser.showSaveDialog(frame);
  if (option == JFileChooser.APPROVE_OPTION) {
    file = fileChooser.getSelectedFile();
    filePath = file.getPath();
    filePathNoExt = removeExtension(filePath);
    logArea.append("filePath: " + filePath + "\n");
    frame.setTitle(filePath);
    String lastComponent = file.getName();
    appName = removeExtension(lastComponent);
    logArea.append("appName: " + appName + "\n");
    if (file == null) {
      return;
    }
  } else {
    logArea.append("SaveAs cancelled.");
  }
  try {
    String content = txtArea.getText();
    if (!file.exists()) {
      file.createNewFile();
    }
    FileWriter fw = new FileWriter(file) ;
    BufferedWriter bw = new BufferedWriter(fw);
    bw.write(content);
    bw.close();
    frame.setTitle(filePath);
  }
  catch (IOException e) {
    logArea.append(e + "\n");
  }
}

void folderSelectionAction() {
  JFileChooser chooser = new JFileChooser();
  chooser.setDialogTitle("Select folder:");
  chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
  if (chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
    File file = chooser.getSelectedFile();
    File dir = chooser.getCurrentDirectory();
    folderStr = dir + "/" + file.getName();
    logArea.append("folder to open:" + dir + "/" + file.getName() + "\n");
  } else {
    logArea.append("No selection." + "\n");
  }
}

void clearAllAction() {
  txtArea.setText("");
  logArea.setText("");
}

void clearLogAction() {
  logArea.setText("");
}

void loadSims() {
  ProcessBuilder  processBuilder = new ProcessBuilder("/bin/sh", "-c", "xcrun simctl list devices");
  try {
    Process process = processBuilder.start();
    BufferedReader stdIn = new BufferedReader(new InputStreamReader(process.getInputStream()));
    BufferedReader stdErr = new BufferedReader(new InputStreamReader(process.getErrorStream()));
    String outStr = "";
    while ((outStr = stdIn.readLine()) != null) {
      String editStr = outStr.replace("(Shutdown)", "");
      simsComboBox.addItem(editStr);
    }
    String errStr = "";
    while ((errStr = stdErr.readLine()) != null) {
      logArea.append(errStr + "\n");
    }
    // Wait for the process to complete and get its exit value
    int exitCode = process.waitFor();
    logArea.append("Process exited with code: " + exitCode + "\n");
  }
  catch (IOException | InterruptedException e) {
    logArea.append(e + "\n");
  }
  logArea.append("======================= end loadSims =========================== " + "\n");
}

void bootAction() {
  StringBuilder sb = new StringBuilder("xcrun simctl boot ");
  sb.append(uuid);
  String bootStr = sb.toString(); // Converts to a String
  logArea.append(bootStr + "\n");
  ProcessBuilder  processBuilder = new ProcessBuilder("/bin/sh", "-c", bootStr);
  try {
    Process process = processBuilder.start();
    BufferedReader stdIn = new BufferedReader(new InputStreamReader(process.getInputStream()));
    BufferedReader stdErr = new BufferedReader(new InputStreamReader(process.getErrorStream()));
    String outStr = "";
    while ((outStr = stdIn.readLine()) != null) {
      logArea.append(outStr + "\n");
    }
    String errStr = "";
    while ((errStr = stdErr.readLine()) != null) {
      logArea.append(errStr + "\n");
    }
    // Wait for the process to complete and get its exit value
    int exitCode = process.waitFor();
    logArea.append("Process exited with code: " + exitCode + "\n");
  }
  catch (IOException | InterruptedException e) {
    logArea.append(e + "\n");
  }
  logArea.append(" ====================== end boot action ===================== " + "\n");
}

void installIOSApp() {
  filePathNoExt = removeExtension(filePath);
  String bndlPath = filePathNoExt + ".app" ;
  StringBuilder sb = new StringBuilder("xcrun simctl install ");
  sb.append(uuid);
  sb.append(" ");
  sb.append(bndlPath);
  String installStr = sb.toString(); // Converts to a String
  logArea.append(installStr + "\n");

  ProcessBuilder  processBuilder = new ProcessBuilder("/bin/sh", "-c", installStr);
  try {
    Process process = processBuilder.start();
    BufferedReader stdIn = new BufferedReader(new InputStreamReader(process.getInputStream()));
    BufferedReader stdErr = new BufferedReader(new InputStreamReader(process.getErrorStream()));
    String outStr = "";
    while ((outStr = stdIn.readLine()) != null) {
      logArea.append(outStr + "\n");
    }
    String errStr = "";
    while ((errStr = stdErr.readLine()) != null) {
      logArea.append(errStr + "\n");
    }
    // Wait for the process to complete and get its exit value
    int exitCode = process.waitFor();
    logArea.append("Process exited with code: " + exitCode + "\n");
  }
  catch (IOException | InterruptedException e) {
    logArea.append(e + "\n");
  }
  logArea.append(" ====================== end installIOSApp ===================== " + "\n");
}

void launchIOSApp() {
  String bndlIdentifier = "com.vsquared." + appName;
  StringBuilder sb = new StringBuilder("xcrun simctl launch ");
  sb.append(uuid);
  sb.append(" ");
  sb.append(bndlIdentifier);
  String launchStr = sb.toString(); // Converts to a String
  logArea.append(launchStr + "\n");

  ProcessBuilder  processBuilder = new ProcessBuilder("/bin/sh", "-c", launchStr);
  try {
    Process process = processBuilder.start();
    BufferedReader stdIn = new BufferedReader(new InputStreamReader(process.getInputStream()));
    BufferedReader stdErr = new BufferedReader(new InputStreamReader(process.getErrorStream()));
    String outStr = "";
    while ((outStr = stdIn.readLine()) != null) {
      logArea.append(outStr + "\n");
    }
    String errStr = "";
    while ((errStr = stdErr.readLine()) != null) {
      logArea.append(errStr + "\n");
    }
    // Wait for the process to complete and get its exit value
    int exitCode = process.waitFor();
    logArea.append("Process exited with code: " + exitCode + "\n");
  }
  catch (IOException | InterruptedException e) {
    logArea.append(e + "\n");
  }
  logArea.append(" ====================== end launchIOSApp ===================== " + "\n");
}

void launchSimulatorApp() {
  ProcessBuilder  processBuilder = new ProcessBuilder("/bin/sh", "-c", "open -a Simulator");
  try {
    Process process = processBuilder.start();
    BufferedReader stdIn = new BufferedReader(new InputStreamReader(process.getInputStream()));
    BufferedReader stdErr = new BufferedReader(new InputStreamReader(process.getErrorStream()));
    String outStr = "";
    while ((outStr = stdIn.readLine()) != null) {
      logArea.append(outStr + "\n");
    }
    String errStr = "";
    while ((errStr = stdErr.readLine()) != null) {
      logArea.append(errStr + "\n");
    }
    // Wait for the process to complete and get its exit value
    int exitCode = process.waitFor();
    logArea.append("Process exited with code: " + exitCode + "\n");
  }
  catch (IOException | InterruptedException e) {
    logArea.append(e + "\n");
  }
  logArea.append(" ====================== end launchSimulatorApp ===================== " + "\n");
}

// **** May need to change sdkStr for your system. **** //

void buildExecutable() {
  filePathNoExt = removeExtension(filePath);
  String bndlPath = filePathNoExt + ".app" ;
  String execInstallPath = bndlPath + "/" + appName;
  logArea.append("execInstallPath:" + execInstallPath + "\n");
  String sdkStr = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator18.2.sdk";
  String targetStr = "arm64-apple-ios14.4-simulator";
  ProcessBuilder processBuilder = new ProcessBuilder("/usr/bin/swiftc", filePath, "-sdk", sdkStr, "-target", targetStr, "-o", execInstallPath);
  try {
    Process process = processBuilder.start();
    BufferedReader stdIn = new BufferedReader(new InputStreamReader(process.getInputStream()));
    BufferedReader stdErr = new BufferedReader(new InputStreamReader(process.getErrorStream()));
    String outStr = "";
    while ((outStr = stdIn.readLine()) != null) {
      logArea.append(outStr + "\n");
    }
    String errStr = "";
    while ((errStr = stdErr.readLine()) != null) {
      logArea.append(errStr + "\n");
    }
    // Wait for the process to complete and get its exit value
    int exitCode = process.waitFor();
    logArea.append("Process exited with code: " + exitCode + "\n");
  }
  catch (IOException | InterruptedException e) {
    logArea.append(e + "\n");
  }
  logArea.append("==================== end buildExecutable ==========================" + "\n");
}

void buildPlist() {
  String bndlIdentifier = "com.vsquared." + appName;
  String bndlPath = filePathNoExt + ".app" ;
  try {
    NSDictionary rootDict = new NSDictionary();
    rootDict.put("CFBundleDevelopmentRegion", "en");
    rootDict.put("CFBundleExecutable", appName);
    rootDict.put("CFBundleDisplayName", appName);
    rootDict.put("CFBundleIdentifier", bndlIdentifier);
    rootDict.put("CFBundleInfoDictionaryVersion", "6.0");
    rootDict.put("CFBundleName", appName);
    rootDict.put("CFBundleVersion", "1.0.2");
    rootDict.put("CFBundleShortVersionString", "1.0.2");
    rootDict.put("CFBundleIconFiles", "");
    rootDict.put("NSPrincipalClass", "UIApplication");
    rootDict.put("LSRequiresIPhoneOS", true); // boolean key
    NSArray capabilities = new NSArray(2);
    capabilities.setValue(0, "arm64");
    capabilities.setValue(1, "armv7");
    rootDict.put("UIRequiredDeviceCapabilities", capabilities);
    rootDict.put("UIApplicationSupportsIndirectInputEvents", true);
    NSArray orientations = new NSArray(3);
    orientations.setValue(0, "UIInterfaceOrientationPortrait");
    orientations.setValue(1, "UIInterfaceOrientationLandscapeLeft");
    orientations.setValue(2, "UIInterfaceOrientationLandscapeRight");
    rootDict.put("UISupportedInterfaceOrientations", orientations);
    File plist = new File(bndlPath + "/Info.plist");
    BinaryPropertyListWriter.write(rootDict, plist);
    logArea.append("Info.plist created successfully at: " + plist.getAbsolutePath()+ "\n");
  }
  catch (Exception e) {
    e.printStackTrace();
  }
  logArea.append("==================== end buildPlist =========================="+"\n");
}

void buildBundle() {
  String bndlPath = filePathNoExt + ".app" ;
  File bndlDir = new File(bndlPath);
  logArea.append("bndlDir:" + bndlDir + "\n");
  if (!bndlDir.exists()) {
    boolean created = bndlDir.mkdirs(); // Use mkdirs() to ensure parents are created
    if (created) {
      logArea.append("Directory created successfully." + "\n");
      buildExecutable();
      buildPlist();
    } else {
      logArea.append("Failed to create directory." + "\n");
    }
  } else {
    logArea.append("Directory already exists." + "\n");
    buildExecutable();
    buildPlist();
  }
  logArea.append("==================== end buildBundle =========================="+"\n");
}

void toolBar() {
  toolbar = new JToolBar();
  toolbar.setLayout(null);
  toolbar.setFloatable(false);
  JScrollPane tbarScrlPane = new JScrollPane(toolbar);
  toolbar.setPreferredSize(new Dimension(_wndW-20, 50));
  frame.add(tbarScrlPane, BorderLayout.PAGE_START);
}

void txtArea() {
  txtArea = new RSyntaxTextArea();
  txtArea.setSyntaxEditingStyle(SyntaxConstants.SYNTAX_STYLE_PYTHON);
  txtArea.setFont(new Font("Menlo", Font.PLAIN, 14));
  txtScrlPane = new RTextScrollPane(txtArea);
  txtArea.setEditable(true);
  txtArea.setLineWrap(false);
  txtArea.setWrapStyleWord(true);
  txtArea.repaint();
  frame.add(txtScrlPane);
}

void logArea() {
  logArea = new JTextArea();
  logScrlPane = new JScrollPane(logArea);
  logArea.setEditable(true);
  logArea.setFont(new Font("Menlo", Font.PLAIN, 12));
  logArea.setLineWrap(false);
  logArea.setWrapStyleWord(true);
  logArea.repaint();
}

//Create a split pane with the two scroll panes in it.
void splitPane() {
  splitPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT, txtScrlPane, logScrlPane);
  splitPane.setBounds(0, 0, _wndW, _wndH - 30);
  splitPane.setOneTouchExpandable(true);
  frame.add(splitPane);
  splitPane.setDividerLocation(_wndH - 210);
  splitPane.repaint();
  //Provide minimum sizes for the two components in the split pane
  Dimension minimumSize = new Dimension(_wndW, 50);
  txtScrlPane.setMinimumSize(minimumSize);
  logScrlPane.setMinimumSize(minimumSize);
}

void popUpMenu() {
  pupMenu = new JPopupMenu();
  fileBtn = new JButton("File");
  fileBtn.setBounds(10, 10, 60, 24);
  fileBtn.setToolTipText("File menu.");
  toolbar.add(fileBtn);
  fileBtn.addActionListener(new ActionListener() {
    public void actionPerformed(ActionEvent e) {
      String s = e.getActionCommand();
      if (s.equals("File")) {
        // add the popup to the toolbar
        pupMenu.show(toolbar, 10, 35);
      }
    }
  }
  );

  // ===== Open ===== //
  JMenuItem mItemOpen = new JMenuItem("Open...");
  mItemOpen.addActionListener(e-> {
    openAction();
  }
  );
  pupMenu.add(mItemOpen);

  // ===== Save ====== //
  JMenuItem mItemSave = new JMenuItem("Save");
  mItemSave.addActionListener(e-> {
    saveAction();
  }
  );
  mItemSave.setAccelerator(KeyStroke.getKeyStroke('S', META_DOWN_MASK));
  pupMenu.add(mItemSave);

  // ===== SaveAs ===== //
  JMenuItem mItemSaveAs = new JMenuItem("SaveAs...");
  mItemSaveAs.addActionListener(e-> {
    saveAsAction();
  }
  );
  pupMenu.add(mItemSaveAs);

  // ===== Separator ===== //
  pupMenu.addSeparator();

  // ==== ClearAll ==== //
  JMenuItem mItemClearAll = new JMenuItem("ClearAll");
  mItemClearAll.addActionListener(e-> {
    clearAllAction();
  }
  );
  pupMenu.add(mItemClearAll);

  // ==== ClearLog ==== //
  JMenuItem mItemClearLog = new JMenuItem("ClearLog");
  mItemClearLog.addActionListener(e-> {
    clearLogAction();
  }
  );
  pupMenu.add(mItemClearLog);
}

void folderSelectionBtn() {
  JButton folderSelectionBtn = new JButton("Folder->open");
  folderSelectionBtn.setBounds(85, 10, 90, 24);
  folderSelectionBtn.setToolTipText("Select folder to open.");
  toolbar.add(folderSelectionBtn);
  folderSelectionBtn.addActionListener(e-> {
    folderSelectionAction();
  }
  );
}

void getUUID(String sim) {
  int endIndex = sim.lastIndexOf(')');
  if (endIndex > -1) {
    int startIndex = sim.lastIndexOf('(');
    uuid = sim.substring(startIndex + 1, endIndex);
    logArea.append("uuid: " + uuid + "\n");
  }
}

void simsComboBox() {
  simsComboBox = new JComboBox();
  simsComboBox.setBounds(185, 10, 540, 24);
  simsComboBox.setToolTipText("Simulators");
  simsComboBox.setMaximumRowCount(30);
  toolbar.add(simsComboBox);
  simsComboBox.addActionListener(e-> {
    String selectedSim = (String) simsComboBox.getSelectedItem();
    String trimStr = selectedSim.trim();
    logArea.append("selectedSim: " + trimStr + "\n");
    getUUID(trimStr);
  }
  );
}

void runBtn() {
  runBtn = new RunButton();
  runBtn.setBounds(_wndW - 110, 5, 34, 34);
  runBtn.setToolTipText("Run code.");
  runBtn.addMouseListener(new MouseAdapter() {
    public void mousePressed(MouseEvent me) {
      toolbar.setCursor(Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR));
      buildBundle();
      bootAction();
      installIOSApp();
      launchIOSApp();
      launchSimulatorApp();
      toolbar.setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
    }
  }
  );
  toolbar.add(runBtn);
  runBtn.repaint();
}

void quitBtn() {
  quitBtn = new QuitButton();
  quitBtn.setBounds(_wndW - 60, 5, 34, 34);
  quitBtn.setToolTipText("Quit editor.");
  quitBtn.addMouseListener(new MouseAdapter() {
    public void mousePressed(MouseEvent me) {
      exit();
    }
  }
  );
  toolbar.add(quitBtn);
  quitBtn.repaint();
}

void buildWnd() {
  toolBar();
  txtArea(); // RSyntaxTextArea
  logArea();
  splitPane();
  popUpMenu();
  folderSelectionBtn();
  runBtn();
  simsComboBox();
  quitBtn();
  frame.setVisible(true);

  loadSims();
}

void setup() {
  surface.setVisible(false);
  frame = new JFrame();
  frame.setBounds(100, 100, _wndW, _wndH);
  frame.setTitle("iOS Editor");
  frame.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
  SwingUtilities.invokeLater(new Runnable() {
    public void run() {
      buildWnd();   // Build components on the EventDispatchThread(EDT).
    }
  }
  );
}
