# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit cmake python-any-r1 xdg

DESCRIPTION="A hierarchical note taking application (C++ version)"
HOMEPAGE="https://www.giuspen.com/cherrytree/"

SRC_URI="https://github.com/giuspen/${PN}/releases/download/v$PV/${P/-/_}.tar.xz"
S="${WORKDIR}"/${P/-/_}

# GPL-3 — future/src/ct (CherryTree)
# LGPL-2.1 — future/src/7za (7zip)
# MIT — future/src/fmt (libfmt)
LICENSE="GPL-3 LGPL-2.1 MIT"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="nls test"

# Has deps that aren't available in ::gentoo repo
RESTRICT="test"

RDEPEND="app-i18n/uchardet
	app-text/gspell:=
	>=dev-cpp/glibmm-2.64.2:2
	dev-cpp/gtkmm:3.0
	dev-cpp/gtksourceviewmm:3.0
	dev-cpp/libxmlpp:2.6
	dev-cpp/pangomm:1.4
	dev-db/sqlite:3
	dev-libs/fribidi
	dev-libs/glib:2
	dev-libs/libfmt:=
	dev-libs/libsigc++:2
	dev-libs/libxml2:2
	>=dev-libs/spdlog-1.5
	>=x11-libs/vte-0.70.2:2.91
	net-misc/curl
	x11-libs/cairo[X]
	x11-libs/gtk+:3[X]
	x11-libs/pango[X]"

DEPEND="${PYTHON_DEPS}
	${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? ( dev-util/cpputest )"

src_prepare() {
	# disable compress man pages
	sed -i -e \
		'/install(FILES/s|${MANFILE_FULL_GZ}|${CMAKE_SOURCE_DIR}/data/cherrytree.1|' \
		CMakeLists.txt || die

	# python_fix_shebang .
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DPYTHON_EXEC="${PYTHON}"
		-DUSE_NLS=$(usex nls)
		-DBUILD_TESTING=$(usex test)
		-DUSE_SHARED_FMT_SPDLOG=ON
	)

	cmake_src_configure
}
