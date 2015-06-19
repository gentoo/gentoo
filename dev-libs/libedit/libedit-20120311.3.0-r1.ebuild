# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libedit/libedit-20120311.3.0-r1.ebuild,v 1.14 2014/08/10 20:35:21 slyfox Exp $

EAPI=2

inherit eutils toolchain-funcs versionator base

MY_PV=$(get_major_version)-$(get_after_major_version)
MY_P=${PN}-${MY_PV}

DESCRIPTION="BSD replacement for libreadline"
HOMEPAGE="http://www.thrysoee.dk/editline/"
SRC_URI="http://www.thrysoee.dk/editline/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="static-libs"

DEPEND=">=sys-libs/ncurses-5.7-r5[static-libs?]
	!<=sys-freebsd/freebsd-lib-6.2_rc1"

RDEPEND=${DEPEND}

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-ncursesprivate.patch"
	"${FILESDIR}/${PN}-20100424.3.0-bsd.patch"
	"${FILESDIR}/${PN}-20110709.3.0-weak-reference.patch"
	"${FILESDIR}/${PN}-20120311-3.0-el_fn_sh_complete.patch"
	)

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--enable-widec \
		--disable-dependency-tracking \
		--enable-fast-install
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	find "${D}" -name '*.la' -delete

	gen_usr_ldscript -a edit
}
