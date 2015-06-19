/*
 * Main.java The main application class.
 *
 * Created on May 1, 2007, 6:32 PM
 *
 * Copyright (C) 2007,2008 Petteri Räty <betelgeuse@gentoo.org>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
package javadepchecker;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.HashSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.bcel.classfile.ClassParser;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.TreeSet;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.bcel.classfile.ConstantClass;
import org.apache.bcel.classfile.ConstantPool;
import org.apache.bcel.classfile.DescendingVisitor;
import org.apache.bcel.classfile.EmptyVisitor;
import org.apache.bcel.classfile.JavaClass;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.cli.PosixParser;

/**
 *
 * @author betelgeuse
 */
public final class Main extends EmptyVisitor {

    static private String image = "";
    private ConstantPool pool;
    private TreeSet<String> deps = new TreeSet<String>();
    private HashSet<String> current = new HashSet<String>();

    /** Creates a new instance of Main */
    public Main() {
    }

    private static Collection<String> getPackageJars(String pkg) {
        ArrayList<String> jars = new ArrayList<String>();
        try {
            Process p = Runtime.getRuntime().exec("java-config -p " + pkg);
            p.waitFor();
            BufferedReader in;
            in = new BufferedReader(new InputStreamReader(p.getInputStream()));
            String output = in.readLine();
            if (!output.trim().equals("")) {
                for (String jar : output.split(":")) {
                    jars.add(jar);
                }
            }
        } catch (InterruptedException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }
        return jars;
    }

    public void processJar(JarFile jar) throws IOException {
        for (Enumeration<JarEntry> e = jar.entries(); e.hasMoreElements();) {
            JarEntry entry = e.nextElement();
            String name = entry.getName();
            if (!entry.isDirectory() && name.endsWith(".class")) {
                this.current.add(name);
                InputStream stream = jar.getInputStream(entry);
                ClassParser parser = new ClassParser(stream, name);
                JavaClass jclass = parser.parse();
                this.pool = jclass.getConstantPool();
                new DescendingVisitor(jclass, this).visitConstantPool(this.pool);
            }
        }
    }

    private static boolean depNeeded(String pkg, Collection<String> deps) throws IOException {
        for (String jarName : getPackageJars(pkg)) {
            JarFile jar = new JarFile(jarName);
            for (Enumeration<JarEntry> e = jar.entries(); e.hasMoreElements();) {
                String name = e.nextElement().getName();
                if (deps.contains(name)) {
                    return true;
                }
            }
        }
        return false;
    }

    private static boolean checkPkg(File env) {
        boolean needed = true;
        HashSet<String> pkgs = new HashSet<String>();
        Collection<String> deps = null;

        BufferedReader in = null;
        try {
            Pattern dep_re = Pattern.compile("^DEPEND=\"([^\"]*)\"$");
            Pattern cp_re = Pattern.compile("^CLASSPATH=\"([^\"]*)\"$");

            String line;
            in = new BufferedReader(new FileReader(env));
            while ((line = in.readLine()) != null) {
                Matcher m = dep_re.matcher(line);
                if (m.matches()) {
                    String atoms = m.group(1);
                    for (String atom : atoms.split(":")) {
                        String pkg = atom;
                        if (atom.contains("@")) {
                            pkg = atom.split("@")[1];
                        }
                        pkgs.add(pkg);
                    }
                    continue;
                }
                m = cp_re.matcher(line);
                if (m.matches()) {
                    Main classParser = new Main();
                    for (String jar : m.group(1).split(":")) {
                        classParser.processJar(new JarFile(image + jar));
                    }
                    deps = classParser.getDeps();
                }
            }

            for (String pkg : pkgs) {
                if (!depNeeded(pkg, deps)) {
                    System.out.println(pkg);
                    needed = false;
                }
            }
        } catch (IOException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                in.close();
            } catch (IOException ex) {
                Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return needed;
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException {
        int exit = 0;
        try {
            CommandLineParser parser = new PosixParser();
            Options options = new Options();
            options.addOption("h", "help", false, "print help");
            options.addOption("i", "image", true, "image directory");
            options.addOption("v","verbose", false, "print verbose output");
            CommandLine line = parser.parse(options, args);
            String[] files = line.getArgs();
            if (line.hasOption("h") || files.length == 0) {
                HelpFormatter h = new HelpFormatter();
                h.printHelp("java-dep-check [-i <image] <package.env>+", options);
            } else {
                image = line.getOptionValue("i", "");

                for (String arg : files) {
                    if(line.hasOption('v'))
                        System.out.println("Checking " + arg);
                    if (!checkPkg(new File(arg))) {
                        exit = 1;
                    }
                }
            }
        } catch (ParseException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }
        System.exit(exit);
    }

    /**
     * Find referenced class from signature if the signature is for a array
     * type.
     * @see http://java.sun.com/docs/books/jvms/second_edition/html/ClassFile.doc.html
     */
    private String stripArray(String signature) {
        String[] result = signature.split("^\\[+L");
        if (result.length == 2) {
            return result[1].substring(0, result[1].length() - 1);
        } else {
            return signature;
        }
    }

    @Override
    public void visitConstantClass(ConstantClass obj) {
        String className = obj.getBytes(pool);
        deps.add(stripArray(className) + ".class");
    }

    private Collection<String> getDeps() {
        ArrayList<String> result = new ArrayList<String>();
        for (String s : deps) {
            if (!current.contains(s)) {
                result.add(s);
            }
        }
        return result;
    }
}
