# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/xwxapt/xwxapt-2.1.ebuild,v 1.1 2012/11/02 18:31:25 tomjbe Exp $

EAPI=4

inherit autotools

DESCRIPTION="GTK+ linux weather satellite APT image decoder software"
HOMEPAGE="http://5b4az.chronos.org.uk/pages/apt.html"
SRC_URI="http://5b4az.chronos.org.uk/pkg/apt/${PN}/${P}.tar.bz2"

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

S=${WORKDIR}/${PN}

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
