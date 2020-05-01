# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

MY_PN="Routes"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A re-implementation of Rails routes system, mapping URLs to Controllers/Actions"
HOMEPAGE="https://routes.readthedocs.io/en/latest/ https://pypi.org/project/Routes/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc"

RDEPEND="
	>=dev-python/repoze-lru-0.3[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

BDEPEND="
	test? ( dev-python/webob[${PYTHON_USEDEP}] )"

distutils_enable_tests nose
distutils_enable_sphinx doc

# The testsuite appears to be held back by the author

# https://github.com/bbangert/routes/issues/42 presents a patch
# for the faulty docbuild converted to sed stmnts
python_prepare_all() {
	# The default theme in sphinx switched to classic from shpinx-1.3.1
	if has_version ">=dev-python/sphinx-1.3.1"; then
		sed -e "s:html_theme_options = {:html_theme = 'classic'\n&:" \
			-i docs/conf.py || die
	else
		sed -e "s:html_theme_options = {:html_theme = 'default'\n&:" \
			-i docs/conf.py || die
	fi
	sed -e "s:changes:changes\n   todo:" \
		-i docs/index.rst || die

	distutils-r1_python_prepare_all
}
