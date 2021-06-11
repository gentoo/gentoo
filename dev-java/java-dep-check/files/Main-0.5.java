/**
 * This file is part of javadepchecker
 *
 * Copyright (C) 2016 Gentoo Foundation
 *
 * javadepchecker is free software; you can redistribute it and/or
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
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Set;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Properties;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.cli.PosixParser;

import org.objectweb.asm.AnnotationVisitor;
import org.objectweb.asm.ClassReader;
import org.objectweb.asm.ClassVisitor;
import org.objectweb.asm.FieldVisitor;
import org.objectweb.asm.Label;
import org.objectweb.asm.MethodVisitor;
import org.objectweb.asm.Opcodes;
import org.objectweb.asm.Type;

/**
 * Main Class of javadepchecker
 * Gentoo Java Utility to scan class files for unneeded dependencies and 
 * ophaned class files
 *
 * @author Petteri Räty <betelgeuse@gentoo.org>
 * @author Serkan Kaba <serkan@gentoo.org>
 * @author William L. Thomson Jr., <wlt@o-sinc.com>
 */
public final class Main extends ClassVisitor {

    static private String image = "";
    private Set<String> mDeps = new HashSet<>();
    private Set<String> mCurrent = new HashSet<>();

    /**
     * Empty Constructor, sets ASM op code version
     */
    public Main() {
        super(Opcodes.ASM5);
    }

    /**
     * Get jar names from the Gentoo package and store in a collection
     *
     * @param pkg Gentoo package name
     * @return a collection of jar names
     */
    private static Collection<String> getPackageJars(String pkg) {
        ArrayList<String> jars = new ArrayList<>();
        try {
            Process p = Runtime.getRuntime().exec("java-config -p " + pkg);
            p.waitFor();
            BufferedReader in;
            in = new BufferedReader(new InputStreamReader(p.getInputStream()));
            String output = in.readLine();
            if (output!=null/* package somehow missing*/ &&
                !output.trim().isEmpty()) {
                jars.addAll(Arrays.asList(output.split(":")));
            }
        } catch (InterruptedException | IOException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }
        return jars;
    }

    /**
     * Scan jar for classes to be processed by ASM
     *
     * @param jar jar file to be processed
     * @throws IOException
     */
    public void processJar(JarFile jar) throws IOException {
        Collections.list(jar.entries())
                   .stream()
                   .filter((JarEntry entry) -> (!entry.isDirectory() && entry.getName().endsWith("class")))
                   .forEach((JarEntry entry) -> {
            InputStream is = null;
            try {
                Main.this.mCurrent.add(entry.getName());
                is = jar.getInputStream(entry);
                new ClassReader(is).accept(Main.this, 0);
            } catch (IOException ex) {
                Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                try {
                    if(is!=null)
                        is.close();
                } catch (IOException ex) {
                    Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        });
    }

    /**
     * Check if a dependency is needed by a given package
     *
     * @param pkg Gentoo package name
     * @param deps collection of dependencies for the package
     * @return boolean if the dependency is needed or not
     * @throws IOException
     */
    private static boolean depNeeded(String pkg,
                                     Collection<String> deps) throws IOException {
        Collection<String> jars = getPackageJars(pkg);

        // We have a virtual with VM provider here
        if (jars.isEmpty()) {
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

    /**
     * Check for orphaned class files not owned by any package in dependencies
     *
     * @param pkg Gentoo package name
     * @param deps collection of dependencies for the package
     * @return boolean if the dependency is found or not
     * @throws IOException
     */
    private static boolean depsFound(Collection<String> pkgs,
                                     Collection<String> deps) throws IOException {
        boolean found = true;
        Collection<String> jars = new ArrayList<>();

        pkgs.forEach((String pkg) -> {
            jars.addAll(getPackageJars(pkg));
        });

        if (jars.isEmpty()) {
            return false;
        }
        ArrayList<String> jarClasses = new ArrayList<>();
        jars.forEach((String jarName) -> {
            try {
                JarFile jar = new JarFile(jarName);
                Collections.list(jar.entries()).forEach((JarEntry entry) -> {
                    jarClasses.add(entry.getName());
                });
            } catch (IOException ex) {
                Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
            }
        });
        for (String dep : deps) {
            if (!jarClasses.contains(dep)) {
		boolean systemClass = false;

		if (!dep.startsWith("org/apache/commons/cli/") && !dep.startsWith("org/objectweb/asm/")) {
			try {
				Class.forName(dep.replaceAll("\\.class$", "").replace('/', '.'));
				systemClass = true;
			} catch (final ClassNotFoundException ex) {
				// it's not a syste class
			}
		}

		if (!systemClass) {
	                if (found) {
        	            System.out.println("Class files not found via DEPEND in package.env");
                	}
	                System.out.println("\t" + dep);
        	        found = false;
		}
            }
        }
        return found;
    }

    /**
     * Core method, this one fires off all others and is the one called from
     * Main. Check this package for unneeded dependencies and orphaned class
     * files
     *
     * @param env
     * @return 
     */
    private static boolean checkPkg(File env) {
        boolean needed = true;
        boolean found = true;
        HashSet<String> pkgs = new HashSet<>();
        Collection<String> deps = null;
        InputStream is = null;

        try {
            // load package.env
            Properties props = new Properties();
            is = new FileInputStream(env);
            props.load(is);

            // load package deps, add to hashset if exist
            String depend = props.getProperty("DEPEND");
            if(depend!=null &&
               !depend.isEmpty()) {
                for (String atom : depend.replaceAll("\"","").split(":")) {
                    String pkg = atom;
                    if (atom.contains("@")) {
                        pkg = atom.split("@")[1];
                    }
                    pkgs.add(pkg);
                }
            }

            // load package classpath
            String classpath = props.getProperty("CLASSPATH");
            if(classpath!=null &&
               !classpath.isEmpty()) {
                Main classParser = new Main();
                for (String jar : classpath.replaceAll("\"","").split(":")) {
                    if (jar.endsWith(".jar")) {
                        classParser.processJar(new JarFile(image + jar));
                    }
                }
                deps = classParser.getDeps();
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
                if(is!=null)
                    is.close();
            } catch (IOException ex) {
                Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return needed && found;
    }

    /** Main method, parse command line opts, invoke the package checker
     * @param args the command line arguments
     * @throws java.io.IOException
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

    /**
     * Add dependency to deps hashset
     *
     * @param dep dependent class name
     */
    private void addDep(String dep) {
        mDeps.add(dep + ".class");
    }

    /**
     * Add dependency type to deps hashset
     *
     * @param dep dependent class name
     */
    private void addDep(Type dep) {
        if (dep.getSort() == Type.ARRAY) {
            addDep(dep.getElementType());
        }
        if (dep.getSort() == Type.OBJECT) {
            addDep(dep.getInternalName());
        }
    }
    
    /**
     * Get deps not contained in the current hashset
     *
     * @return a collection of deps
     */
    private Collection<String> getDeps() {
        ArrayList<String> result = new ArrayList<>();
        mDeps.stream().filter((s) -> (!mCurrent.contains(s))).forEach((s) -> {
            result.add(s);
        });
        return result;
    }

    @Override
    public void visit(int version,
                      int access,
                      String name,
                      String signature,
                      String superName,
                      String[] interfaces) {
        if(superName != null) {
            addDep(superName);
        }
        for (String iface : interfaces) {
            addDep(iface);
        }
    }

    @Override
    public FieldVisitor visitField(int access,
                                   String name,
                                   String desc,
                                   String signature,
                                   Object value) {
        addDep(Type.getType(desc));
        return null;
    }

    @Override
    public MethodVisitor visitMethod(int access,
                                     String name,
                                     String desc,
                                     String signature,
                                     String[] exceptions) {
        for (Type param : Type.getArgumentTypes(desc)) {
            addDep(param);
        }

        if (exceptions != null) {
            for (String exception : exceptions) {
                addDep(exception);
            }
        }
        addDep(Type.getReturnType(desc));
        return new MethodVisitor(Opcodes.ASM5) {
            @Override
            public void visitLocalVariable(String name,
                                           String desc,
                                           String signature,
                                           Label start,
                                           Label end,
                                           int index) {
                addDep(Type.getType(desc));
            }

            @Override
            public void visitFieldInsn(int opcode,
                                       String owner,
                                       String name,
                                       String desc) {
                addDep(Type.getObjectType(owner));
                addDep(Type.getType(desc));
            }

            @Override
            public void visitMethodInsn(int opcode,
                                        String owner,
                                        String name,
                                        String desc,
                                        boolean itf) {
                addDep(Type.getObjectType(owner));
            }

            @Override
            public AnnotationVisitor visitParameterAnnotation(int parameter,
                                                              String desc,
                                                              boolean visible) {
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
