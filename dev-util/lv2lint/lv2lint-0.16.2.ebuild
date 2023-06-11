# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Check whether a given LV2 plugin is up to the specification"
HOMEPAGE="https://git.open-music-kontrollers.ch/~hp/lv2lint"
SRC_URI="https://git.open-music-kontrollers.ch/~hp/lv2lint/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic-2 CC0-1.0 ISC"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"

DEPEND="
	media-libs/lilv
	media-libs/lv2
	virtual/libelf
"
RDEPEND="${DEPEND}"

src_configure() {
	# TODO: on next release (>0.16.2), wire up -Dbuild-tests
	local emesonargs=(
		-Db_lto=false

		# See README, these are for runtime tests of *other* things (plugins)
		-Donline-tests=disabled
		-Delf-tests=enabled
		-Dx11-tests=disabled
	)

	meson_src_configure
}
