# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An HTTP authentication brute forcer"
HOMEPAGE="http://www.divineinvasion.net/authforce/"
SRC_URI="http://www.divineinvasion.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="curl nls"

RDEPEND="sys-libs/readline:0=
	curl? ( net-misc/curl )"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

DOCS=( AUTHORS BUGS NEWS README THANKS TODO )

PATCHES=(
	"${FILESDIR}"/${P}-curl.patch
	"${FILESDIR}"/${P}-locale.patch
)

src_prepare() {
	default
	gunzip doc/${PN}.1.gz
	sed -i -e "s/${PN}.1.gz/${PN}.1/g" \
		-e "s/\/mang/\/man1/g" doc/Makefile* || die
}

src_configure() {
	econf \
		$(use_with curl) \
		$(use_enable nls) \
		--with-path=/usr/share/${PN}/data:.
}

src_install() {
	default
	doman doc/${PN}.1
}
