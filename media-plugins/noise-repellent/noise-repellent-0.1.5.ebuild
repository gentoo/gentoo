# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="An lv2 plug-in for broadband noise reduction"
HOMEPAGE="https://github.com/lucianodato/noise-repellent"
SRC_URI="https://github.com/lucianodato/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	media-libs/lv2
"
RDEPEND="
	sci-libs/fftw:3.0
"
DEPEND="${RDEPEND}"

src_configure() {
	local emesonargs=(
		--prefix="${EPREFIX}/usr/$(get_libdir)/lv2"
	)
	meson_src_configure
}
