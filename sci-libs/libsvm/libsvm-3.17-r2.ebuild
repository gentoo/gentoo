# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit flag-o-matic java-pkg-opt-2 python-r1 toolchain-funcs

DESCRIPTION="Library for Support Vector Machines"
HOMEPAGE="http://www.csie.ntu.edu.tw/~cjlin/libsvm/"
SRC_URI="http://www.csie.ntu.edu.tw/~cjlin/libsvm/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="java openmp python tools"

DEPEND="java? ( >=virtual/jdk-1.4 )"
RDEPEND="
	java? ( >=virtual/jre-1.4 )
	tools? ( sci-visualization/gnuplot )"

PATCHES=(
	"${FILESDIR}/3.11-openmp.patch"
	"${FILESDIR}/3.14-makefile.patch"
)

pkg_setup() {
	if use openmp; then
		if ! tc-has-openmp; then
			ewarn "OpenMP is not supported by your currently selected compiler"

			if tc-is-clang; then
				ewarn "OpenMP support in sys-devel/clang is provided by sys-libs/libomp,"
				ewarn "which you will need to build ${CATEGORY}/${PN} for USE=\"openmp\""
			fi

			die "need openmp capable compiler"
		fi

		append-cflags -fopenmp
		append-cxxflags -fopenmp
		append-cppflags -DOPENMP
	fi
}

src_prepare() {
	default

	sed -i -e "s@\.\./@${EPREFIX}/usr/bin/@g" tools/*.py \
		|| die "Failed to fix paths in python files"
	sed -i -e "s|./grid.py|${EPREFIX}/usr/bin/svm-grid|g" tools/*.py \
		|| die "Failed to fix paths for svm-grid"
	sed -i -e 's/grid.py/svm-grid/g' tools/grid.py \
		|| die "Failed to rename grid.py to svm-grid"

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

	dodoc README

	if use tools; then
		python_setup

		local t
		for t in tools/*.py; do
			python_newscript ${t} svm-$(basename ${t} .py)
		done

		newdoc tools/README README.tools

		insinto /usr/share/doc/${PF}/examples
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

	docinto html
	if use java; then
		java-pkg_dojar java/libsvm.jar
		dodoc java/test_applet.html
	fi

	dodoc FAQ.html
}
