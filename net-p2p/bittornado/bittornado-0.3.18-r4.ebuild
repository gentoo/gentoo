# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# note: wxGTK interface has been removed wrt #391685. this ebuild is only for
# cmdline tools as is.

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=BitTornado
MY_P=${MY_PN}-${PV}

DESCRIPTION="TheShad0w's experimental BitTorrent client"
HOMEPAGE="http://www.bittornado.com/"
SRC_URI="http://download2.bittornado.com/download/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND="dev-python/pycrypto[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	app-arch/unzip
	>=sys-apps/sed-4.0.5"

S=${WORKDIR}/${MY_PN}-CVS
PIXMAPLOC=/usr/share/pixmaps/bittornado

python_prepare_all() {
	# fixes wrong icons path
	sed -i "s:os.path.abspath(os.path.dirname(os.path.realpath(sys.argv\[0\]))):\"${PIXMAPLOC}/\":" btdownloadgui.py
	# Needs wxpython-2.6 only, bug #201247
	eapply "${FILESDIR}"/${P}-wxversion.patch

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install

	# get rid of any reference to the not-installed gui version
	rm "${ED%/}"/usr/bin/*gui.py || die
	rm "${ED%/}$(python_get_scriptdir)"/*gui.py || die
}

python_install_all() {
	distutils-r1_python_install_all

	newconfd "${FILESDIR}"/bttrack.conf bttrack
	newinitd "${FILESDIR}"/bttrack.rc bttrack
}
