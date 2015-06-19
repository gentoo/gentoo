# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/nevow/nevow-0.11.1.ebuild,v 1.7 2015/04/08 08:04:57 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit twisted-r1

DESCRIPTION="A web templating framework that provides LivePage, an automatic AJAX toolkit"
HOMEPAGE="http://divmod.org/trac/wiki/DivmodNevow http://pypi.python.org/pypi/Nevow"
SRC_URI="mirror://pypi/${TWISTED_PN:0:1}/${TWISTED_PN}/${TWISTED_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-linux"
IUSE="doc"

DEPEND="dev-python/twisted-core[${PYTHON_USEDEP}]
	dev-python/twisted-web[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

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
