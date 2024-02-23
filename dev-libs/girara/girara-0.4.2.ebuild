# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson virtualx

DESCRIPTION="UI library that focuses on simplicity and minimalism"
HOMEPAGE="https://pwmt.org/projects/girara/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/${PN}.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://pwmt.org/projects/girara/download/${P}.tar.xz"
	KEYWORDS="~amd64 arm ~arm64 ~riscv ~x86"
fi

LICENSE="ZLIB"
SLOT="0"
IUSE="doc libnotify test"

RESTRICT="!test? ( test )"

RDEPEND="
	app-accessibility/at-spi2-core
	dev-libs/glib:2
	dev-libs/json-glib:=
	media-libs/harfbuzz:=
	x11-libs/cairo[glib]
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-3.20:3
	x11-libs/pango
	libnotify? ( x11-libs/libnotify )
"
# Tests are run under virtx
DEPEND="
	${RDEPEND}
	test? (
		dev-libs/check
		x11-base/xorg-proto
		x11-libs/gtk+:3[X]
	)
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

src_configure() {
	local -a emesonargs=(
		-Djson=enabled
		$(meson_feature doc docs)
		$(meson_feature libnotify notify)
	)
	meson_src_configure
}

src_test() {
	# TODO: run test on wayland
	virtx meson_src_test
}
