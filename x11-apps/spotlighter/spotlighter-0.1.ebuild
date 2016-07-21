# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

SRC_URI="https://ardesia.googlecode.com/files/${P}.tar.gz"
DESCRIPTION="Shows a movable and resizable spotlight on the screen"
HOMEPAGE="https://code.google.com/p/ardesia/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

COMMON_DEPEND="sys-devel/gettext
	x11-libs/gtk+:2"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool"
RDEPEND="${COMMON_DEPEND}
	dev-libs/atk
	media-libs/fontconfig
	>=media-libs/libpng-1.2
	sci-libs/gsl"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}
