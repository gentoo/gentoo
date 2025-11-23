# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Cross platform native file dialog library with C and C++ bindings"
HOMEPAGE="https://github.com/btzy/nativefiledialog-extended/"
SRC_URI="
	https://github.com/btzy/nativefiledialog-extended/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+desktop-portal"

DEPEND="
	desktop-portal? ( sys-apps/dbus )
	!desktop-portal? (
		dev-libs/glib:2
		x11-libs/gtk+:3
	)
"
RDEPEND="
	${DEPEND}
	desktop-portal? ( sys-apps/xdg-desktop-portal )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.1-libdir.patch
)

src_configure() {
	local mycmakeargs=(
		# tests are non-automated examples that open interactive dialogs
		-DNFD_BUILD_TESTS=no
		-DNFD_PORTAL=$(usex desktop-portal)
	)

	cmake_src_configure
}
