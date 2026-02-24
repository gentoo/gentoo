# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Collection of libraries which implement some freedesktop.org specifications"
HOMEPAGE="https://gitlab.freedesktop.org/vyivel/libsfdo"
SRC_URI="https://gitlab.freedesktop.org/vyivel/libsfdo/-/archive/v${PV}/libsfdo-v${PV}.tar.bz2"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	# examples are only built, not installed
	local emesonargs=(
		-Dexamples=false
		$(meson_use test tests)
	)
	meson_src_configure
}
