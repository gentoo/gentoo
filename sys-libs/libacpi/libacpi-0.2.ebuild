# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libacpi/libacpi-0.2.ebuild,v 1.1 2010/07/08 13:57:24 ssuominen Exp $

EAPI=2
inherit eutils multilib toolchain-funcs

DESCRIPTION="A general purpose library for ACPI"
HOMEPAGE="http://www.ngolde.de/libacpi.html"
SRC_URI="http://www.ngolde.de/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
}

src_compile() {
	tc-export AR CC RANLIB
	emake || die
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)" install || die
	prepalldocs
}
