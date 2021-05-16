# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{7,8,9} )
inherit toolchain-funcs distutils-r1

DESCRIPTION="Routing application based on openstreetmap data"
HOMEPAGE="https://routino.org/"
SRC_URI="https://routino.org/download/${P}.tgz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="python test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

DEPEND="
	python? (
		${PYTHON_DEPS}
		dev-lang/swig
	)
"
RDEPEND="python? ( ${PYTHON_DEPS} )"

PATCHES=( "${FILESDIR}"/${P}.patch )

src_prepare() {
	default

	sed -i -e "s@libdir=\(.*\)@libdir=\$(prefix)/$(get_libdir)@" \
		-e "s@CC=gcc@CC=$(tc-getCC)@" \
		-e "s@LD=gcc@LD=$(tc-getCC)@" \
		Makefile.conf || die "failed sed"
}

src_compile() {
	emake -j1
	rm README.txt || die "rm README.txt failed"
	mv doc/README.txt . || die "mv doc/README.txt . failed"
	if use python; then
		pushd python > /dev/null
		python_compile() {
			rm -f build/.timestamp || die
			emake PYTHON=${EPYTHON}
		}
		python_foreach_impl python_compile
		popd > /dev/null
	fi
}

src_test() {
	emake test
#	if use python; then
#		pushd python > /dev/null
#		python_test() {
#			echo "######## ${EPYTHON} ########"
#			emake PYTHON=${EPYTHON} test
#		}
#		python_foreach_impl python_test
#		popd > /dev/null
#	fi
}

src_install() {
	default
	if use python; then
		pushd python > /dev/null
		python_install() {
			esetup.py install
			python_optimize
		}
		python_foreach_impl python_install
		newdoc README.txt README_python.txt
		popd > /dev/null
	fi

}
