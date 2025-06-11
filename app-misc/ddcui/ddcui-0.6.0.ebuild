# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Check for bumps & cleanup with app-misc/ddcutil

inherit cmake xdg

DESCRIPTION="Graphical user interface for ddcutil - control monitor settings"
HOMEPAGE="https://www.ddcutil.com/ddcui_main/"
SRC_URI="https://github.com/rockowitz/ddcui/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/glib
	>=app-misc/ddcutil-2.2.0:0/5
	>=dev-qt/qtbase-6.1:6[gui,widgets]
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-0.5.3-drop-qthelp-dep.patch"
)

src_prepare() {
	# move docs to correct dir
	sed -i -e "s%share/doc/ddcui%share/doc/${PF}%g" CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# Not quite there yet, so force off
		-DUSE_QT6=ON
	)

	cmake_src_configure
}
