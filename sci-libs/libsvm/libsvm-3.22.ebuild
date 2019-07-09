# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit flag-o-matic java-pkg-opt-2 python-r1 toolchain-funcs

DESCRIPTION="Library for Support Vector Machines"
HOMEPAGE="https://www.csie.ntu.edu.tw/~cjlin/libsvm/"
SRC_URI="https://www.csie.ntu.edu.tw/~cjlin/libsvm/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="java openmp python tools"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	java? ( >=virtual/jdk-1.4 )
	python? ( ${PYTHON_DEPS} )"
RDEPEND="
	java? ( >=virtual/jre-1.4 )
	python? ( ${PYTHON_DEPS} )
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
	doheader svm.h

	DOCS=( README )

	if use tools; then
		local t
		for t in tools/*.py; do
			python_foreach_impl python_newscript ${t} svm-$(basename ${t} .py)
		done

		mv tools/README{,.tools} || die
		DOCS+=( tools/README.tools )

		insinto /usr/share/doc/${PF}/examples
		docompress -x /usr/share/doc/${PF}/examples
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

		mv python/README{,.python} || die
		DOCS+=( python/README.python )
	fi

	HTML_DOCS=( FAQ.html )
	if use java; then
		java-pkg_dojar java/libsvm.jar
		HTML_DOCS+=( java/test_applet.html )
	fi

	einstalldocs
}
