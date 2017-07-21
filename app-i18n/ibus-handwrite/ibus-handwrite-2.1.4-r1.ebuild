# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 autotools-utils multilib

DESCRIPTION="hand write recognition/input using ibus IM engine"
HOMEPAGE="https://code.google.com/p/ibus-handwrite/"
SRC_URI="https://ibus-handwrite.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls +zinnia"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="zinnia? ( app-i18n/zinnia app-i18n/zinnia-tomoe )
	>=app-i18n/ibus-1.3.0
	>=x11-libs/gtk+-2.10:2
	x11-libs/gtkglext
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-link.patch #bug #501954
}

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		$(use_enable zinnia)
		$(use_with zinnia zinnia-tomoe "${EPREFIX}"/usr/$(get_libdir)/zinnia/model/tomoe)
	)
	autotools-utils_src_configure
}
