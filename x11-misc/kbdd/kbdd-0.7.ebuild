# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/kbdd/kbdd-0.7.ebuild,v 1.2 2012/12/27 06:10:52 qnikst Exp $

EAPI=4

inherit autotools eutils

DESCRIPTION="Very simple layout switcher"
HOMEPAGE="http://github.com/qnikst/kbdd"
SRC_URI="https://github.com/qnikst/kbdd/tarball/v${PV} -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus"

DEPEND="dev-libs/glib
		x11-libs/libX11
		dbus? (
			sys-apps/dbus
			>=dev-libs/dbus-glib-0.86
			)"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_prepare() {
	cd "${WORKDIR}"/qnikst-kbdd-*
	epatch "${FILESDIR}"/kbdd-0.7-fix-non-dbus-build.patch
	S=$(pwd)
	eautoreconf
}

src_configure() {
	econf $(use_enable dbus) || die "econf failed"
}
