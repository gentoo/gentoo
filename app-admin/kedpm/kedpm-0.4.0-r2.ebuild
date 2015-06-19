# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/kedpm/kedpm-0.4.0-r2.ebuild,v 1.4 2015/02/25 15:46:12 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="Ked Password Manager helps to manage large amounts of passwords and related information"
HOMEPAGE="http://kedpm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="gtk"

DEPEND="dev-python/pycrypto[${PYTHON_USEDEP}]
	gtk? ( >=dev-python/pygtk-2[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS CHANGES NEWS )

python_prepare_all() {
	# We want documentation to install in /usr/share/doc/kedpm
	# not in /usr/share/kedpm as in original setup.py.
	local PATCHES=(
		"${FILESDIR}/setup-doc.patch"
	)

	# If we don't compiling with GTK support, let's change default
	# frontend for kedpm to CLI.
	use gtk || sed -i -e 's/"gtk"  # default/"cli"  # default/' scripts/kedpm

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" run_tests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	# menu item
	domenu "${FILESDIR}/${PN}.desktop"
}
