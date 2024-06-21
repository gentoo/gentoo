# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Japanese input method Anthy IMEngine for SCIM"
HOMEPAGE="http://scim-imengine.sourceforge.jp/index.cgi?cmd=view;name=SCIMAnthy"
SRC_URI="
	mirror://sourceforge.jp/scim-imengine/37309/${P}.tar.gz
	https://dev.gentoo.org/~juippis/distfiles/tmp/${PN}-1.2.7-gtk2_build.patch
	gtk3? ( https://dev.gentoo.org/~heroxbd/${P}-patches.tar.xz )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm sparc x86"
IUSE="+gtk3 nls kasumi"

DEPEND="
	>=app-i18n/anthy-5900
	>=app-i18n/scim-1.2[gtk3=]
	nls? ( virtual/libintl )
	gtk3? ( x11-libs/gtk+:3 )
"
RDEPEND="${DEPEND}
	kasumi? ( app-dicts/kasumi )
"
BDEPEND="
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

src_prepare() {
	default

	if use gtk3; then
		eapply "${WORKDIR}"/patches/*.patch
	else
		eapply "${DISTDIR}"/${P}-gtk2_build.patch
	fi

	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	local DOCS=( AUTHORS ChangeLog NEWS README )
	default

	# plugin module, no point in .la files
	find "${D}" -type f -name '*.la' -delete || die
}
