# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic xdg-utils

DESCRIPTION="Beaver is an Early AdVanced EditoR"
HOMEPAGE="https://sourceforge.net/projects/beaver-editor/"
SRC_URI="mirror://sourceforge/beaver-editor/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	>=dev-libs/glib-2.14:2
	>=x11-libs/gtk+-2.10:2
"
DEPEND="
	${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
PATCHES=(
	"${FILESDIR}"/${PN}-0.4.1-desktop-file-validate.patch
)

src_configure() {
	append-cflags -fgnu89-inline

	econf \
		$(use_enable doc doxygen-doc) \
		--disable-debug
}

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
