# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="GTK+ linux weather satellite APT image decoder software"
HOMEPAGE="https://www.qsl.net/5b4az/pages/apt.html"
SRC_URI="https://www.qsl.net/5b4az/pkg/apt/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/glib:2
	media-libs/alsa-lib
	net-wireless/rtl-sdr
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-3.4.2-fix-autotools.patch )
HTML_DOCS=( doc/xwxapt.html )

src_prepare() {
	default

	# create missing mkinstalldir and prepare package
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
