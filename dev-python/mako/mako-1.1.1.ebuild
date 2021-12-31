# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( pypy3 python{2_7,3_{6,7,8}} )

inherit distutils-r1 eutils

MY_PN="Mako"
MY_P=${MY_PN}-${PV}

DESCRIPTION="A Python templating language"
HOMEPAGE="https://www.makotemplates.org/ https://pypi.org/project/Mako/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 s390 ~sh sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc"

RDEPEND=">=dev-python/markupsafe-0.9.2[${PYTHON_USEDEP}]"

DEPEND="
	test? (
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' -2)
	)
"

PATCHES=(
	"${FILESDIR}"/mako-1.1.1-pypy3-test.patch
)

distutils_enable_tests pytest

python_install_all() {
	rm -r doc/build || die

	use doc && local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}

pkg_postinst() {
	elog "Optional dependencies:"
	optfeature "caching support" dev-python/beaker
}
