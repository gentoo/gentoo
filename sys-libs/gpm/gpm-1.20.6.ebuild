# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/gpm/gpm-1.20.6.ebuild,v 1.15 2011/08/11 02:25:13 vapier Exp $

# emacs support disabled due to #99533 #335900

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Console-based mouse driver"
HOMEPAGE="http://www.nico.schottelius.org/software/gpm/"
SRC_URI="http://www.nico.schottelius.org/software/${PN}/archives/${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="selinux"

DEPEND="sys-libs/ncurses
	app-arch/xz-utils
	virtual/yacc"
RDEPEND="selinux? ( sec-policy/selinux-gpm )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.20.5-abi.patch
	epatch "${FILESDIR}"/0001-daemon-use-sys-ioctl.h-for-ioctl.patch #222099
	epatch "${FILESDIR}"/0001-fixup-make-warnings.patch #206291

	# workaround broken release
	find -name '*.o' -delete
}

src_configure() {
	econf \
		--sysconfdir=/etc/gpm \
		emacs=/bin/false
}

src_compile() {
	# make sure nothing compiled is left
	emake clean || die
	emake EMACS=: || die
}

src_install() {
	emake install DESTDIR="${D}" EMACS=: ELISP="" || die

	dosym libgpm.so.1 /usr/$(get_libdir)/libgpm.so
	gen_usr_ldscript -a gpm

	insinto /etc/gpm
	doins conf/gpm-*.conf

	dodoc BUGS Changes README TODO
	dodoc doc/Announce doc/FAQ doc/README*

	newinitd "${FILESDIR}"/gpm.rc6 gpm
	newconfd "${FILESDIR}"/gpm.conf.d gpm
}
