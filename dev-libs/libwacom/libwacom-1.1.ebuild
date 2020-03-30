# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson udev toolchain-funcs

DESCRIPTION="Library for identifying Wacom tablets and their model-specific features"
HOMEPAGE="https://github.com/linuxwacom/libwacom"
SRC_URI="https://github.com/linuxwacom/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~ia64 ppc ppc64 sparc x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-libs/glib:2
	dev-libs/libgudev:=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-meson-add-private.patch"
	"${FILESDIR}/${P}-match-with-autotools.patch"
	"${FILESDIR}/${P}-configurable_docs.patch"
)

pkg_setup() {
	tc-ld-disable-gold # bug https://github.com/linuxwacom/libwacom/issues/170
}

src_configure() {
	local emesonargs=(
		$(meson_feature doc documentation)
		$(meson_use test tests)
		-Dudev-dir=$(get_udevdir)

	)
	meson_src_configure
}
