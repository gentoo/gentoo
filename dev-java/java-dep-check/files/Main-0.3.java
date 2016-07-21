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
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.cli.PosixParser;
import org.objectweb.asm.AnnotationVisitor;
import org.objectweb.asm.ClassReader;
import org.objectweb.asm.FieldVisitor;
import org.objectweb.asm.Label;
import org.objectweb.asm.MethodVisitor;
import org.objectweb.asm.Type;
import org.objectweb.asm.commons.EmptyVisitor;

/**
 *
 * @author betelgeuse
 * @author serkan
 */
public final class Main extends EmptyVisitor {

    static private String image = "";
    private Set<String> deps = new HashSet<String>();
    private Set<String> current = new HashSet<String>();

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
            if (output!=null/* package somehow missing*/ && !output.trim().equals("")) {
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
                new ClassReader(stream).accept(this, 0);
            }
        }
    }

    private static boolean depNeeded(String pkg, Collection<String> deps) throws IOException {
        Collection<String> jars = getPackageJars(pkg);
        // We have a virtual with VM provider here
        if (jars.size() == 0) {
            return true;
        }
        for (String jarName : jars) {
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

    private static boolean depsFound(Collection<String> pkgs, Collection<String> deps) throws IOException {
        boolean found = true;
        Collection<String> jars = new ArrayList<String>();
        String[] bootClassPathJars = System.getProperty("sun.boot.class.path").split(":");
        // Do we need "java-config -r" here?
        for (String jar : bootClassPathJars) {
            File jarFile = new File(jar);
            if (jarFile.exists()) {
                jars.add(jar);
            }
        }
        for (Iterator<String> pkg = pkgs.iterator(); pkg.hasNext();) {
            jars.addAll(getPackageJars(pkg.next()));
        }

        if (jars.size() == 0) {
            return false;
        }
        ArrayList<String> jarClasses = new ArrayList<String>();
        for (String jarName : jars) {
            JarFile jar = new JarFile(jarName);
            for (Enumeration<JarEntry> e = jar.entries(); e.hasMoreElements();) {
                jarClasses.add(e.nextElement().getName());
            }
        }
        for (String dep : deps) {
            if (!jarClasses.contains(dep)) {
                if (found) {
                    System.out.println("Class files not found via DEPEND in package.env");
                }
                System.out.println("\t" + dep);
                found = false;
            }
        }
        return found;
    }

    private static boolean checkPkg(File env) {
        boolean needed = true;
        boolean found = true;
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
                        if (jar.endsWith(".jar")) {
                            classParser.processJar(new JarFile(image + jar));
                        }
                    }
                    deps = classParser.getDeps();
                }
            }

            for (String pkg : pkgs) {
                if (!depNeeded(pkg, deps)) {
                    if (needed) {
                        System.out.println("Possibly unneeded dependencies found");
                    }
                    System.out.println("\t" + pkg);
                    needed = false;
                }
            }
            found = depsFound(pkgs, deps);

        } catch (IOException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                in.close();
            } catch (IOException ex) {
                Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return needed && found;
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
            options.addOption("v", "verbose", false, "print verbose output");
            CommandLine line = parser.parse(options, args);
            String[] files = line.getArgs();
            if (line.hasOption("h") || files.length == 0) {
                HelpFormatter h = new HelpFormatter();
                h.printHelp("java-dep-check [-i <image>] <package.env>+", options);
            } else {
                image = line.getOptionValue("i", "");

                for (String arg : files) {
                    if (line.hasOption('v')) {
                        System.out.println("Checking " + arg);
                    }
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

    private void addDep(String dep) {
        deps.add(dep + ".class");
    }

    private void addDep(Type dep) {
        if (dep.getSort() == Type.ARRAY) {
            addDep(dep.getElementType());
        }
        if (dep.getSort() == Type.OBJECT) {
            addDep(dep.getInternalName());
        }
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

    @Override
    public void visit(int version, int access, String name, String signature, String superName, String[] interfaces) {
        if(superName != null) {
            addDep(superName);
        }
        for (String iface : interfaces) {
            addDep(iface);
        }
    }

    @Override
    public FieldVisitor visitField(int access, String name, String desc, String signature, Object value) {
        addDep(Type.getType(desc));
        return null;
    }

    @Override
    public MethodVisitor visitMethod(int access, String name, String desc, String signature, String[] exceptions) {
        for (Type param : Type.getArgumentTypes(desc)) {
            addDep(param);
        }

        if (exceptions != null) {
            for (String exception : exceptions) {
                addDep(exception);
            }
        }
        addDep(Type.getReturnType(desc));
        return new EmptyVisitor() {
            @Override
            public void visitLocalVariable(String name, String desc, String signature, Label start, Label end, int index) {
                addDep(Type.getType(desc));
            }

            @Override
            public void visitFieldInsn(int opcode, String owner, String name, String desc) {
                addDep(Type.getObjectType(owner));
                addDep(Type.getType(desc));
            }

            @Override
            public void visitMethodInsn(int opcode, String owner, String name, String desc) {
                addDep(Type.getObjectType(owner));
            }

            @Override
            public AnnotationVisitor visitParameterAnnotation(int parameter, String desc, boolean visible) {
                return Main.this.visitAnnotation(desc, visible);
            }
        };
    }

    @Override
    public AnnotationVisitor visitAnnotation(String desc, boolean visible) {
        addDep(Type.getType(desc));
        return null;
    }
}
