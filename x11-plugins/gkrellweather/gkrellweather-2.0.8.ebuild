# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic gkrellm-plugin toolchain-funcs

DESCRIPTION="GKrellM2 Plugin that monitors a METAR station and displays weatherinfo"
HOMEPAGE="https://sites.google.com/site/makovick/gkrellm-plugins"
SRC_URI="https://sites.google.com/site/makovick/projects/${P}.tgz"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""

RDEPEND="
	>=dev-lang/perl-5.6.1
	>=net-misc/wget-1.5.3"
DEPEND=">=sys-apps/sed-4.0.5
	virtual/pkgconfig
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-Respect-LDFLAGS.patch \
		"${FILESDIR}"/${P}-Move-GrabWeather.patch
	append-cflags $($(tc-getPKG_CONFIG) --cflags gtk+-2.0)
	append-flags -fPIC

}

src_compile() {
	emake PREFIX=/usr CC=$(tc-getCC) CFLAGS="${CFLAGS}"
}

src_install () {
	gkrellm-plugin_src_install

	exeinto /usr/libexec/gkrellweather
	doexe GrabWeather
}
