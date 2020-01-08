# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit twisted-r1

DESCRIPTION="A web templating framework that provides LivePage, an automatic AJAX toolkit"
HOMEPAGE="https://github.com/twisted/nevow https://pypi.org/project/Nevow/"
SRC_URI="mirror://pypi/${TWISTED_PN:0:1}/${TWISTED_PN}/${TWISTED_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	|| (
		dev-python/twisted[${PYTHON_USEDEP}]
		(
			dev-python/twisted-core[${PYTHON_USEDEP}]
			dev-python/twisted-web[${PYTHON_USEDEP}]
		)
	)
	dev-python/zope-interface[${PYTHON_USEDEP}]"
# JS tests require a JavaScript interpreter ('smjs' or 'js' in PATH)
# and the subunit library
DEPEND="${RDEPEND}
	test? (
		dev-lang/spidermonkey
		dev-python/subunit[${PYTHON_USEDEP}]
	)"

TWISTED_PLUGINS=( nevow.plugins )

python_test() {
	trial formless nevow || die "tests failed with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	touch "${D}$(python_get_sitedir)"/nevow/plugins/dropin.cache || die
}

python_install_all() {
	distutils-r1_python_install_all

	# TODO: prevent installing it
	rm -r "${D}"/usr/doc || die
}
