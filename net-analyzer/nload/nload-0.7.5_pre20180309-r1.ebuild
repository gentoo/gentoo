# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# We avoid xdg.eclass here because it'll pull in glib & desktop utils
# Headless machines do not need them. Related: #787470
inherit autotools desktop xdg-utils

GIT_REV="8f92dc04fad283abdd2a4538cd4c2093d957d9da"

DESCRIPTION="TUI realtime network traffic monitor"
HOMEPAGE="https://www.roland-riegel.de/nload/"
SRC_URI="https://github.com/rolandriegel/nload/archive/${GIT_REV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GIT_REV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~x86"

RDEPEND=">=sys-libs/ncurses-5.2:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.5_pre-tinfo.patch
	"${FILESDIR}"/${PN}-0.7.5_pre-Makefile-spec-don-t-compress-man-page.patch
)

src_prepare() {
	default
	sed -i "/AC_INIT/ s/0\.7\.4/${PV} (Gentoo)/" \
		configure.ac || die "Failed to patch configure.ac"

	eautoreconf
}

src_install() {
	default
	domenu "${FILESDIR}"/${PN}.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
