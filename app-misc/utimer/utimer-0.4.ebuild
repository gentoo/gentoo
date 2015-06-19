# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/utimer/utimer-0.4.ebuild,v 1.3 2011/06/29 18:52:43 maekke Exp $

EAPI=2

DESCRIPTION="A command line timer and stopwatch"
HOMEPAGE="http://utimer.codealpha.net/utimer"
SRC_URI="http://utimer.codealpha.net/dl.php?file=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug nls"

DEPEND=">=dev-libs/glib-2.18.2
	>=dev-util/intltool-0.40.5"
RDEPEND="${RDEPEND}"

src_configure() {
	local myconf=
	if use debug; then
		myconf="--enable-debug=yes"
	else
		myconf="--enable-debug=no"
	fi
	econf ${myconf} $(use_enable nls)
}

src_install() {
	emake install DESTDIR="${D}" || die "failed to install"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
