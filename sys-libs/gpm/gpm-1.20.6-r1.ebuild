# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/gpm/gpm-1.20.6-r1.ebuild,v 1.1 2012/10/26 20:45:14 flameeyes Exp $

# emacs support disabled due to #99533 #335900

EAPI=4

inherit eutils toolchain-funcs autotools

DESCRIPTION="Console-based mouse driver"
HOMEPAGE="http://www.nico.schottelius.org/software/gpm/"
SRC_URI="http://www.nico.schottelius.org/software/${PN}/archives/${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="selinux static-libs"

CDPEND="sys-libs/ncurses"
DEPEND="${CDEPEND}
	app-arch/xz-utils
	virtual/yacc"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-gpm )"

src_prepare() {
	epatch "${FILESDIR}"/0001-daemon-use-sys-ioctl.h-for-ioctl.patch #222099
	epatch "${FILESDIR}"/0001-fixup-make-warnings.patch #206291
	epatch "${FILESDIR}"/${P}-disablestatic.patch #378283

	# fix ABI values
	sed -i \
		-e 's/^abi_lev=.*$/abi_lev="1"/' \
		-e 's/^abi_age=.*$/abi_age="20"/' \
		configure.ac || die

	# workaround broken release
	find -name '*.o' -delete

	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir=/etc/gpm \
		$(use_enable static-libs static) \
		emacs=/bin/false
}

src_compile() {
	# make sure nothing compiled is left
	emake clean
	emake EMACS=:
}

src_install() {
	emake install DESTDIR="${D}" EMACS=: ELISP=""

	dosym libgpm.so.1 /usr/$(get_libdir)/libgpm.so
	gen_usr_ldscript -a gpm

	insinto /etc/gpm
	doins conf/gpm-*.conf

	dodoc BUGS Changes README TODO
	dodoc doc/Announce doc/FAQ doc/README*

	newinitd "${FILESDIR}"/gpm.rc6-2 gpm
	newconfd "${FILESDIR}"/gpm.conf.d gpm
}
