# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )
inherit distutils-r1

MY_PN="A${PN:1}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Self-service finite-state machines for the programmer on the go"
HOMEPAGE="https://github.com/glyph/automat https://pypi.org/project/Automat/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="examples"

RDEPEND="
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/m2r[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/automat-0.8.0-no-setup-py-m2r-import.patch"
	"${FILESDIR}/test_visualize-twisted-import-errors.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	if use test ; then
		# Remove since this is upstream benchmarking tests
		rm -r benchmark || die "FAILED to remove benchmark tests"
	fi

	# avoid a setuptools_scm dependency
	sed -r -i "s:use_scm_version=True:version='${PV}': ;
		s:[\"']setuptools[_-]scm[\"'](,|)::" setup.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc docs/examples/*.py
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	einfo "For additional visualization functionality install both these optional dependencies"
	einfo "    >=dev-python/twisted-16.1.1"
	einfo "    media-gfx/graphviz[python]"
}
