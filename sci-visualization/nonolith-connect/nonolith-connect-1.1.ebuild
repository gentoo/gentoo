# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit scons-utils toolchain-funcs user

DESCRIPTION="CEE (Control - Experiment - Explore) analog multitool"
HOMEPAGE="http://www.nonolithlabs.com/cee/"
SRC_URI="http://apps.nonolithlabs.com/download/source/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-libs/boost
	virtual/udev
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-cflags-respect.patch"
	"${FILESDIR}/${PV}-gcc6.patch"
)

pkg_setup() {
	tc-export CC CXX
	enewuser nonolithd -1 -1 /dev/null usb
}

src_configure() {
	myesconsargs=(
		boost_static=0
	)
}

src_compile() {
	escons
}

src_install() {
	dobin nonolith-connect
	newinitd "${FILESDIR}"/nonolith-connect.initd nonolith-connect
}

pkg_postinst() {
	einfo "Consider adding nonolith-connect to the default runlevel."
	einfo "Please connect your CEE hardware, start nonolith-connect "
	einfo "using the init script provided and then visit:"
	einfo "http://apps.nonolithlabs.com/setup"
}
