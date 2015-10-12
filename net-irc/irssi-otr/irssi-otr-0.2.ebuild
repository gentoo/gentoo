# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=2

inherit cmake-utils eutils

DESCRIPTION="Off-The-Record messaging (OTR) for irssi"
HOMEPAGE="http://irssi-otr.tuxfamily.org"

# This should probably be exported by cmake-utils as a variable
CMAKE_BINARY_DIR="${WORKDIR}"/${PN}_build
mycmakeargs="-DDOCDIR=/usr/share/doc/${PF}"

SRC_URI="ftp://download.tuxfamily.org/irssiotr/${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE="debug"

RDEPEND="<net-libs/libotr-4
	dev-libs/glib
	dev-libs/libgcrypt:0
	dev-libs/libgpg-error
	|| (
		net-irc/irssi
		net-irc/irssi-svn
	)"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.7
	virtual/pkgconfig
	dev-lang/python"

src_install() {
	cmake-utils_src_install
	rm "${D}"/usr/share/doc/${PF}/LICENSE
	prepalldocs
}
