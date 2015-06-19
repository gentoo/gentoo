# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/pax-utils/pax-utils-0.4.ebuild,v 1.8 2012/07/10 18:05:58 ranger Exp $

inherit eutils toolchain-funcs unpacker

DESCRIPTION="ELF related utils for ELF 32/64 binaries that can check files for security relevant properties"
HOMEPAGE="http://hardened.gentoo.org/pax-utils.xml"
SRC_URI="mirror://gentoo/pax-utils-${PV}.tar.xz
	http://dev.gentoo.org/~solar/pax/pax-utils-${PV}.tar.xz
	http://dev.gentoo.org/~vapier/dist/pax-utils-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="caps"
#RESTRICT="mirror"

RDEPEND="caps? ( sys-libs/libcap )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

src_compile() {
	emake CC="$(tc-getCC)" USE_CAP=$(usex caps) || die
}

src_install() {
	emake DESTDIR="${D}" PKGDOCDIR='$(DOCDIR)'/${PF} install || die
	prepalldocs
}
