# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/qbzr/qbzr-0.23.1.ebuild,v 1.3 2015/04/08 17:53:02 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 versionator

DESCRIPTION="Qt frontend for Bazaar"
HOMEPAGE="https://launchpad.net/qbzr"
SRC_URI="https://edge.launchpad.net/qbzr/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE=""

# bzr version comes from NEWS file. It's lowest version required for some
# features to work.
DEPEND=">=dev-vcs/bzr-2.5
		>=dev-python/PyQt4-4.1[X]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

DOCS=( AUTHORS.txt NEWS.txt README.txt TODO.txt )

src_test() {
	elog "It's impossible to run tests at this point. If you wish to run tests"
	elog "after installation of ${PN} execute:"
	elog " $ bzr selftest -s bzrlib.plugins.qbzr"
}

pkg_postinst() {
	distutils_pkg_postinst

	elog
	elog "To enable spellchecking in qcommit, please, install >=dev-python/pyenchant-1.5.0"
	elog " # emerge -a >=dev-python/pyenchant-1.5.0"
	elog "To enable syntax highlighting, please, install dev-python/pygments"
	elog " # emerge -a dev-python/pygments"
}
