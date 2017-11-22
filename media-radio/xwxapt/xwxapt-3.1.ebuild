# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="GTK+ linux weather satellite APT image decoder software"
HOMEPAGE="http://www.qsl.net/5b4az/pages/apt.html"
SRC_URI="http://www.qsl.net/5b4az/pkg/apt/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	net-wireless/rtl-sdr
	media-libs/alsa-lib
	dev-libs/glib:2
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

HTML_DOCS="doc/xwxapt.html"

src_prepare() {
	eapply_user
	# suppress -Weverything flag
	sed -i -e "s/= -Weverything/= /" src/Makefile.am || die
	# create missing mkinstalldir and prepare package
	glib-gettextize --force --copy || die "gettextize failed"
	eautoreconf
}

src_install() {
	default
	insinto /usr/share/${PN}
	doins xwxapt/xwxaptrc
	doins xwxapt/xwxapt.glade
	dodir /usr/share/${PN}/images /usr/share/${PN}/records
}

pkg_postinst() {
	einfo "You must copy the /usr/share/xwxapt directory into your home directory"
	einfo "and configure the contained xwxaptrc file before starting the program"
	ewarn
	ewarn "If you just upgraded from <=xwxapt-3 do not miss to check"
	ewarn "for changes there"
}
