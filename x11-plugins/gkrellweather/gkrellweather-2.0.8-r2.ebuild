# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic gkrellm-plugin toolchain-funcs

DESCRIPTION="GKrellM2 Plugin that monitors a METAR station and displays weatherinfo"
HOMEPAGE="https://sites.google.com/site/makovick/gkrellm-plugins"
SRC_URI="https://sites.google.com/site/makovick/projects/${P}.tgz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"

RDEPEND="
	app-admin/gkrellm:2[X]
	dev-lang/perl
	net-misc/wget
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-Respect-LDFLAGS.patch
	"${FILESDIR}"/${P}-Move-GrabWeather.patch
	"${FILESDIR}"/${P}-update-locations.patch
	"${FILESDIR}"/${P}-r2-makefile-fixes.patch
)

src_configure() {
	append-cflags $($(tc-getPKG_CONFIG) --cflags gtk+-2.0)
	append-flags -fPIC
}

src_compile() {
	tc-export PKG_CONFIG
	emake PREFIX="${EPREFIX}"/usr CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	gkrellm-plugin_src_install

	exeinto /usr/libexec/gkrellweather
	doexe GrabWeather
}
