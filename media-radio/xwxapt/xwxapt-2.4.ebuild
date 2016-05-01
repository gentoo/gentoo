# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="GTK+ linux weather satellite APT image decoder software"
HOMEPAGE="http://www.qsl.net/5b4az/pages/apt.html"
SRC_URI="http://www.qsl.net/5b4az/pkg/apt/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/alsa-lib
	dev-libs/glib:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	# create missing mkinstalldir and prepare package
	glib-gettextize --force --copy || die "gettextize failed"
	eautoreconf
}

src_install() {
	default
	dohtml doc/xwxapt.html
	insinto /usr/share/${PN}
	doins xwxapt/xwxaptrc
	dodir /usr/share/${PN}/images /usr/share/${PN}/records
}

pkg_postinst() {
	einfo "You must copy the /usr/share/xwxapt directory into your home directory"
	einfo "and configure the contained xwxaptrc file before starting the program"
}
