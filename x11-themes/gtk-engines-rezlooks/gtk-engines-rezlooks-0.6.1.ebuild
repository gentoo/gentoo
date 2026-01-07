# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Rezlooks GTK+ Engine"
HOMEPAGE="https://github.com/t-wissmann/rezlooks-gtk-engine"
SRC_URI="https://github.com/t-wissmann/rezlooks-gtk-engine/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/rezlooks-gtk-engine-"${PV}"/rezlooks

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	eautoreconf # update stale autotools
}

src_configure() {
	econf --enable-animation
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
