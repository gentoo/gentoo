# Copyright 2013-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Handwriting model data of Japanese"
HOMEPAGE="https://tegaki.github.io/"
SRC_URI="https://github.com/tegaki/tegaki/releases/download/v${PV}/${P}.zip"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE=""

RDEPEND=""
BDEPEND="app-arch/unzip"

src_prepare() {
	default

	sed -i \
		-e "/^installpath=/s|local/||" \
		-e "/^installpath=/s|=|=${EPREFIX}|" \
		-e "s/\(\$(inst\)/\$(DESTDIR)\1/" \
		Makefile
}

src_compile() {
	:
}
