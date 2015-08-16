# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils libtool multilib-minimal

DESCRIPTION="A library to encapsulate CD-ROM reading and control"
HOMEPAGE="http://www.gnu.org/software/libcdio/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/15" # subslot is based on SONAME
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="cddb +cxx minimal static-libs test"

RDEPEND="
	!minimal? (
		>=sys-libs/ncurses-5.7-r7:5=
		cddb? ( >=media-libs/libcddb-1.3.2 )
	)
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r10
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	sys-apps/sed
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-lang/perl )"
DOCS="AUTHORS ChangeLog NEWS README* THANKS TODO"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/cdio/cdio_config.h
	/usr/include/cdio/version.h
)

src_prepare() {
	sed \
		-e "s:-lncurses:$($(tc-getPKG_CONFIG) --libs ncurses):g" \
		-i configure || die

	elibtoolize # to prevent -L/usr/lib ending up in the linker line wrt 499510
}

multilib_src_configure() {
	local util_switch
	if ! multilib_is_native_abi || use minimal ; then
		util_switch="--without"
	else
		util_switch="--with"
	fi

	# Tests fail if ECONF_SOURCE is not relative
	ECONF_SOURCE="../${P}" econf \
		--disable-maintainer-mode \
		$(use_enable cxx) \
		--disable-cpp-progs \
		--disable-example-progs \
		$(use_enable static-libs static) \
		$(use_enable cddb) \
		--disable-vcd-info \
		${util_switch}-{cd-drive,cd-info,cdda-player,cd-read,iso-info,iso-read}
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
