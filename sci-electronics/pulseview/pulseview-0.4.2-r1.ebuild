# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit cmake xdg-utils

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-r3
else
	SRC_URI="https://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Qt based logic analyzer GUI for sigrok"
HOMEPAGE="https://sigrok.org/wiki/PulseView"

LICENSE="GPL-3"
SLOT="0"
IUSE="+decode static"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
RDEPEND="
	>=dev-cpp/glibmm-2.28.0:2
	dev-libs/boost:=
	>=dev-libs/glib-2.28.0:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	>=sci-libs/libsigrok-0.5.1:=[cxx]
	decode? ( >=sci-libs/libsigrokdecode-0.5.2:= )
"
DEPEND="${RDEPEND}"

DOCS=( HACKING NEWS README )

PATCHES=(
	"${FILESDIR}/${P}-qt-5.15.patch"
	"${FILESDIR}"/${PN}-0.4.2-glib-2.68.patch
)

src_prepare() {
	cmake_src_prepare
	cmake_comment_add_subdirectory manual
}

src_configure() {
	local mycmakeargs=(
		-DDISABLE_WERROR=TRUE
		-DENABLE_DECODE=$(usex decode)
		-DSTATIC_PKGDEPS_LIBS=$(usex static)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
