# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="LV2 port of the MDA plugins by Paul Kellett"
HOMEPAGE="https://drobilla.net/software/mda-lv2.html"
SRC_URI="https://download.drobilla.net/${P}.tar.xz"

# See README
LICENSE="|| ( GPL-2+ MIT )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
IUSE="test"
# Tests fail because of lvz_new_audioeffectx symbol in plugins, check
# on new lv2lint release (>0.16.2). See https://gitlab.com/drobilla/mda-lv2/-/issues/2.
RESTRICT="!test? ( test ) test"

DEPEND="media-libs/lv2"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-util/lv2lint )
"

PATCHES=(
	"${FILESDIR}"/${P}-strict-aliasing.patch
	"${FILESDIR}"/${P}-autoship-disable.patch
)

src_prepare() {
	default

	# reuse isn't packaged right now, but it's only for licencing
	# i.e. it's essentially a lint check so not relevant for us downstream.
	sed -i -e "/reuse = find_program('reuse', required/s:get_option('tests'):false:" meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_feature test tests)
	)

	meson_src_configure
}
