# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/debugedit/debugedit-5.1.9.ebuild,v 1.3 2012/07/29 18:26:20 armin76 Exp $

# To recreate this tarball, just grab latest rpm5 release:
#	http://rpm5.org/files/rpm/
# The files are in tools/

EAPI="2"

inherit toolchain-funcs eutils

DESCRIPTION="Standalone debugedit taken from rpm"
HOMEPAGE="http://www.rpm5.org/"
SRC_URI="http://dev.gentoo.org/~swegener/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="dev-libs/popt
	dev-libs/elfutils
	dev-libs/beecrypt"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-{cleanup,DWARF-3}.patch
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin debugedit || die "dobin failed"
}
