# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="UI library that focuses on simplicity and minimalism"
HOMEPAGE="https://pwmt.org/projects/girara/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pwmt/${PN}.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://github.com/pwmt/girara/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="ZLIB"
SLOT="0/$(ver_cut 2-3)"
IUSE="doc test"
RESTRICT="!test? ( test )"

# REVIEW: are all those really needed?
RDEPEND="
	app-accessibility/at-spi2-core
	>=dev-libs/glib-2.72:2
	dev-libs/json-glib:=
	media-libs/harfbuzz:=
	x11-libs/cairo[glib]
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-3.24:3
	x11-libs/pango
"
DEPEND="
	${RDEPEND}
	test? (
		x11-base/xorg-proto
		x11-libs/gtk+:3[X]
		x11-misc/xvfb-run
	)
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

DOCS=( AUTHORS README.md )

src_configure() {
	local -a emesonargs=(
		-Djson=enabled
		$(meson_feature doc docs)
		$(meson_feature test tests)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
	use doc && HTML_DOCS=( "${BUILD_DIR}"/doc/html/* ) # BUILD_DIR is set by meson_src_compile
}
