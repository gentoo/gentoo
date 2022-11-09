# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils

DESCRIPTION="A filesystem mounter that uses udisks to handle notification and mounting"
HOMEPAGE="https://sourceforge.net/projects/wmudmount/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gcr libnotify secret"

RDEPEND="sys-fs/udisks:2
	>=x11-libs/gtk+-3.16.0:3
	gcr? ( app-crypt/gcr:0=[gtk] )
	libnotify? ( >=x11-libs/libnotify-0.7 )
	secret? ( app-crypt/libsecret )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	virtual/imagemagick-tools[png]"

DOCS="ChangeLog"

PATCHES=( "${FILESDIR}"/${PN}-2.2-perl_brace_regex.patch )

src_configure() {
	econf \
		$(use_with gcr) \
		$(use_with libnotify) \
		$(use_with secret)
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
