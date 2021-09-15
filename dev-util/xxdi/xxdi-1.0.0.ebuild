# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MODULE_VERSION=001

DESCRIPTION="Simple alternative to vim's 'xxd -i' mode"
HOMEPAGE="https://github.com/gregkh/xxdi"
SRC_URI="https://github.com/gregkh/xxdi/archive/v${MODULE_VERSION}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MODULE_VERSION}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ppc ppc64 x86"

RDEPEND="dev-lang/perl
	dev-perl/File-Slurp"

src_install() {
	dobin xxdi.pl
	dodoc README.md
}
