# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Simon Tatham's Portable Puzzle Collection"
HOMEPAGE="https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
MY_HASH=2376227
SRC_URI="https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-${PV}.${MY_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/puzzles-${PV}.${MY_HASH}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="x11-libs/gtk+:3"
RDEPEND="
	${COMMON_DEPEND}
	x11-misc/xdg-utils
"
DEPEND="${COMMON_DEPEND}"
BDEPEND="
	app-text/halibut
	dev-lang/perl
	virtual/imagemagick-tools[png]
	virtual/pkgconfig
"

DOCS=( puzzles.txt HACKING )

PATCHES=(
	"${FILESDIR}"/${PN}-20250904-no-cli.patch
)

src_configure() {
	local mycmakeargs=(
		-DNAME_PREFIX="${PN}_"
		-DPUZZLES_GTK_VERSION=3
	)

	cmake_src_configure
}

src_install() {
	sed -i "s/^Categories=.*/&X-${PN};/" "${BUILD_DIR}"/*.desktop || die

	cmake_src_install

	einstalldocs

	insinto /etc/xdg/menus/applications-merged
	doins "${FILESDIR}/${PN}.menu"
	insinto /usr/share/desktop-directories
	doins "${FILESDIR}/${PN}.directory"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
