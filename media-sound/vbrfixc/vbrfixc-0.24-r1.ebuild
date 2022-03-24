# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Vbrfix fixes MP3s and re-constructs VBR headers"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="ftp://mirror.bytemark.co.uk/gentoo/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
# big-endian ones need vbrfixc-0.24-bigendian.diff from gentoo-x86 cvs Attic
KEYWORDS="amd64 x86"

PATCHES=( "${FILESDIR}"/${P}-gcc43.patch )

src_install() {
	HTML_DOCS=( vbrfixc/docs/en/*.html )
	default
}
