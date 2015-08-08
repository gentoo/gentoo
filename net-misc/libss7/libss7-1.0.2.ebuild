# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit base toolchain-funcs

DESCRIPTION="Signalling System 7 (SS7) protocol library"
HOMEPAGE="http://www.asterisk.org/"
SRC_URI="http://downloads.asterisk.org/pub/telephony/${PN}/releases/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=net-misc/dahdi-2.0.0"
PATCHES=(
	"${FILESDIR}/${PV}-werror-idiocy.patch"
	"${FILESDIR}/${PV}-no-ldconfig.patch"
	"${FILESDIR}/${PV}-ldflags.patch"
)

src_compile() {
	emake CC=$(tc-getCC) LD=$(tc-getLD) DESTDIR="${D}"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README NEWS* || die "dodoc failed"
}
