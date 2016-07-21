# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils flag-o-matic multilib-minimal toolchain-funcs

MY_PN="CUnit"
MY_PV="${PV/_p*}-3"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="C Unit Test Framework"
SRC_URI="mirror://sourceforge/cunit/${MY_P}.tar.bz2"
HOMEPAGE="http://cunit.sourceforge.net"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="ncurses static-libs"

RDEPEND="ncurses? ( >=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS NEWS README ChangeLog )

src_prepare() {
	default

	sed -e "/^docdir/d" -i doc/Makefile.am || die
	sed -e '/^dochdrdir/{s:$(prefix)/doc/@PACKAGE@:$(docdir):}' \
		-i doc/headers/Makefile.am || die
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.in || die
	eautoreconf

	append-cppflags -D_BSD_SOURCE

	# unable to find headers otherwise
	multilib_copy_sources
}

multilib_src_configure() {
	local LIBS=${LIBS}
	append-libs $($(tc-getPKG_CONFIG) --libs ncurses)

	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_enable static-libs static) \
		--disable-debug \
		$(use_enable ncurses curses)
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
