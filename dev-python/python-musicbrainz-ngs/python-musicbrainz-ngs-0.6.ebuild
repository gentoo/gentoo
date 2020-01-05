# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

MY_PN="${PN/%-ngs/ngs}"

DESCRIPTION="Python bindings for the MusicBrainz NGS and the Cover Art Archive webservices"
HOMEPAGE="https://github.com/alastair/python-musicbrainzngs"
SRC_URI="https://github.com/alastair/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_PN}${PV}.tar.gz"

LICENSE="BSD-2 ISC"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES="${FILESDIR}/0.6-fix-test-submit.patch"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Prevent un-needed d'loading
	sed -e "s/^ *'sphinx.ext.intersphinx'//" -i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	esetup.py test --verbosity=2
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && local EXAMPLES=( examples )

	distutils-r1_python_install_all
}
