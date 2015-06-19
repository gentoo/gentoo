# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/abcl/abcl-0.0.9-r1.ebuild,v 1.3 2014/08/10 20:40:51 slyfox Exp $

inherit eutils java-pkg-2

DESCRIPTION="ABCL is an implementation of ANSI Common Lisp that runs in a Java VM"
HOMEPAGE="http://armedbear.org/abcl.html"
SRC_URI="http://armedbear.org/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="jad clisp cmucl"

RDEPEND=">=virtual/jre-1.4
	jad? ( dev-java/jad-bin )"

DEPEND=">=virtual/jdk-1.4
	dev-lang/python
	!cmucl? ( !clisp? ( dev-lisp/sbcl ) )
	cmucl? ( dev-lisp/cmucl )
	clisp? ( dev-lisp/clisp )"

src_unpack() {
	unpack ${A}
	cat > "${S}/customizations.lisp" <<EOF
(in-package #:build-abcl)
(setf
*javac-options* "-g $(java-pkg_javac-args)"
*jikes-options* "+D -g $(java-pkg_javac-args)"
*jdk* "${JAVA_HOME}/"
*java-compiler* "${JAVAC}"
*jar* "jar")
EOF
	einfo "Building with the following customizations.lisp:"
	cat "${S}/customizations.lisp"
	cat >"${S}/build.lisp" <<'EOF'
(progn (load "build-abcl") (funcall (intern "BUILD-ABCL" "BUILD-ABCL") :clean t :full t) #+sbcl (sb-ext:quit) #+clisp (ext:quit) #+cmu (extensions:quit))
EOF
}

getutfvars() {
python << EOF
import os
for key,value in os.environ.iteritems():
	try:
		value.encode()
	except UnicodeDecodeError:
		print key
EOF
}

src_compile() {
	local lisp_compiler lisp_compiler_args
	if use clisp; then
		lisp_compiler="clisp"
		lisp_compiler_args="-ansi build.lisp"
	elif use cmucl; then
		lisp_compiler="lisp"
		lisp_compiler_args="-noinit -nositeinit -batch -load build.lisp"
	else
		lisp_compiler="sbcl"
		lisp_compiler_args="--sysinit /dev/null --userinit /dev/null --disable-debugger --load build.lisp"
	fi

	einfo "Filtering non ASCII environment variables"
	for var in $(getutfvars); do
		einfo "	${var}"
		unset ${var}
	done
	$lisp_compiler $lisp_compiler_args || die
}

src_install() {
	java-pkg_dolauncher ${PN} --java_args "-Xmx256M -Xrs" --main org.armedbear.lisp.Main
	java-pkg_doso src/org/armedbear/lisp/libabcl.so
	java-pkg_dojar abcl.jar
	dodoc README || die
}
