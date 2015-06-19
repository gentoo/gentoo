# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/efreet/efreet-1.7.8.ebuild,v 1.1 2013/08/06 19:47:07 tommy Exp $

EAPI=2

inherit enlightenment

DESCRIPTION="library for handling of freedesktop.org specs (desktop/icon/theme/etc...)"
SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs"

RDEPEND=">=dev-libs/ecore-1.7.8
	>=dev-libs/eet-1.7.8
	>=dev-libs/eina-1.7.8
	x11-misc/xdg-utils"
DEPEND="${RDEPEND}"

#src_prepare() {
#	sed -i "s:1.7.5:1.7.4:g" configure.ac
#	eautoreconf
#}

src_configure() {
	MY_ECONF="
		$(use_enable doc)
	"

	enlightenment_src_configure
}
