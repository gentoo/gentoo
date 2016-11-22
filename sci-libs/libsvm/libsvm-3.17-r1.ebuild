# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )

inherit eutils java-pkg-opt-2 python-r1 flag-o-matic toolchain-funcs

DESCRIPTION="Library for Support Vector Machines"
HOMEPAGE="http://www.csie.ntu.edu.tw/~cjlin/libsvm/"
SRC_URI="http://www.csie.ntu.edu.tw/~cjlin/libsvm/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="java openmp python tools"

DEPEND="java? ( >=virtual/jdk-1.4 )"
RDEPEND="
	java? ( >=virtual/jre-1.4 )
	tools? ( sci-visualization/gnuplot )"

pkg_setup() {
	if use openmp; then
		if [[ $(tc-getCC)$ == *gcc* ]] && ! tc-has-openmp; then
			ewarn "You are using gcc but without OpenMP capabilities"
			die "Need an OpenMP capable compiler"
		else
			append-ldflags -fopenmp
			append-flags -fopenmp
		fi
		append-flags -DOPENMP
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}"/3.11-openmp.patch \
		"${FILESDIR}"/3.14-makefile.patch
	sed -i -e "s@\.\./@${EPREFIX}/usr/bin/@g" tools/*.py \
		|| die "Failed to fix paths in python files"

	if use java; then
		local JAVAC_FLAGS="$(java-pkg_javac-args)"
		sed -i \
			-e "s/JAVAC_FLAGS =/JAVAC_FLAGS=${JAVAC_FLAGS}/g" \
			java/Makefile || die "Failed to fix java makefile"
	fi
	tc-export CXX CC
}

src_compile() {
	default
	use java && emake -C java
}

src_install() {
	dobin svm-train svm-predict svm-scale
	dolib.so *.so*
	insinto /usr/include
	doins svm.h
	dohtml FAQ.html
	dodoc README

	if use tools; then
		local t
		for t in tools/*.py; do
			newbin ${t} svm-$(basename ${t} .py)
		done
		newdoc tools/README README.tools
		insinto /usr/share/doc/${PF}
		doins heart_scale
		doins -r svm-toy
	fi

	if use python ; then
		installation() {
			touch python/__init__.py || die
			python_moduleinto libsvm
			python_domodule python/*.py
		}
		python_foreach_impl installation
		newdoc python/README README.python
	fi

	if use java; then
		java-pkg_dojar java/libsvm.jar
		dohtml java/test_applet.html
	fi
}
