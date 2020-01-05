# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{6,7})

inherit distutils-r1

MYPN="Automat"
MYP="${MYPN}-${PV}"

DESCRIPTION="Self-service finite-state machines for the programmer on the go"
HOMEPAGE="https://github.com/glyph/automat https://pypi.org/project/Automat/"
SRC_URI="mirror://pypi/${MYPN:0:1}/${MYPN}/${MYP}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/m2r[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

S=${WORKDIR}/${MYP}

python_prepare_all() {
	if use test ; then
		# Remove since this is upstream benchmarking tests
		rm -r benchmark || die "FAILED to remove benchmark tests"
	fi
	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH="${S}/test:${BUILD_DIR}/lib" py.test -v || die "Tests failed under ${EPYTHON}"
}

src_install() {
	if use examples; then
		docinto examples
		dodoc docs/examples/*.py
	fi
	distutils-r1_src_install
}

pkg_postinst() {
	einfo "For additional visualization functionality install these optional dependencies"
	einfo "    >=dev-python/twisted-16.1.1"
	einfo "    media-gfx/graphviz[python]"
}
