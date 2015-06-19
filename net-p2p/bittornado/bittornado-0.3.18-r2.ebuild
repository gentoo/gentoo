# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/bittornado/bittornado-0.3.18-r2.ebuild,v 1.5 2012/08/12 22:07:25 ottxor Exp $

# note: wxGTK interface has been removed wrt #391685. this ebuild is only for
# cmdline tools as is.

EAPI=3
PYTHON_DEPEND=2

inherit distutils eutils

MY_PN=BitTornado
MY_P=${MY_PN}-${PV}

DESCRIPTION="TheShad0w's experimental BitTorrent client"
HOMEPAGE="http://www.bittornado.com/"
SRC_URI="http://download2.bittornado.com/download/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="alpha amd64 ppc ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND="dev-python/pycrypto"
DEPEND="${RDEPEND}
	app-arch/unzip
	>=sys-apps/sed-4.0.5"

S=${WORKDIR}/${MY_PN}-CVS
PIXMAPLOC=/usr/share/pixmaps/bittornado

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# fixes wrong icons path
	sed -i "s:os.path.abspath(os.path.dirname(os.path.realpath(sys.argv\[0\]))):\"${PIXMAPLOC}/\":" btdownloadgui.py
	# Needs wxpython-2.6 only, bug #201247
	epatch "${FILESDIR}"/${P}-wxversion.patch

	python_convert_shebangs -r 2 .
}

src_install() {
	distutils_src_install

	# get rid of any reference to the not-installed gui version
	rm "${ED}"/usr/bin/*gui.py

	newconfd "${FILESDIR}"/bttrack.conf bttrack
	newinitd "${FILESDIR}"/bttrack.rc bttrack
}
