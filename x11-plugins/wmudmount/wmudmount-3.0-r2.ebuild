# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Filesystem mounter using udisks to handle notification and mounting"
HOMEPAGE="https://sourceforge.net/projects/wmudmount/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gcr keyring libnotify"

RDEPEND="
	sys-fs/udisks:2
	>=x11-libs/gtk+-3.16.0:3
	gcr? ( app-crypt/gcr:0=[gtk] )
	keyring? ( app-crypt/libsecret )
	libnotify? ( >=x11-libs/libnotify-0.7 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	virtual/imagemagick-tools[png]
"

DOCS="ChangeLog"

PATCHES=( "${FILESDIR}"/${PN}-2.2-perl_brace_regex.patch )

src_configure() {
	econf \
		$(use_with gcr) \
		$(use_with libnotify) \
		$(use_with keyring secret)
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
