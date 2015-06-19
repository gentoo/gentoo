# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libtinynotify/libtinynotify-0.2.1.ebuild,v 1.2 2012/05/05 03:52:27 jdhore Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="A lightweight implementation of Desktop Notification Spec"
HOMEPAGE="https://github.com/mgorny/libtinynotify/"
SRC_URI="mirror://github/mgorny/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc static-libs"

RDEPEND="sys-apps/dbus"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.18 )"

DOCS=( README )

src_configure() {
	myeconfargs=(
		$(use_enable debug)
		$(use_enable doc gtk-doc)
	)

	autotools-utils_src_configure
}
