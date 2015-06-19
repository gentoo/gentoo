# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libtinynotify-systemwide/libtinynotify-systemwide-0.1.ebuild,v 1.2 2014/07/06 13:24:06 mgorny Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="A system-wide notifications module for libtinynotify"
HOMEPAGE="https://bitbucket.org/mgorny/libtinynotify-systemwide/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

RDEPEND="sys-process/procps
	x11-libs/libtinynotify"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )"

src_configure() {
	myeconfargs=(
		$(use_enable doc gtk-doc)
	)

	autotools-utils_src_configure
}
