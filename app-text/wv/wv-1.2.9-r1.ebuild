# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/wv/wv-1.2.9-r1.ebuild,v 1.14 2013/09/13 21:45:53 eva Exp $

EAPI="3"

inherit eutils autotools multilib

DESCRIPTION="Tool for conversion of MSWord doc and rtf files to something readable"
SRC_URI="http://abiword.org/downloads/${PN}/${PV}/${P}.tar.gz"
HOMEPAGE="http://wvware.sourceforge.net/"

IUSE="tools wmf"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"
SLOT="0"
LICENSE="GPL-2"

RDEPEND=">=dev-libs/glib-2
	>=gnome-extra/libgsf-1.13
	sys-libs/zlib
	media-libs/libpng
	dev-libs/libxml2
	tools? ( app-text/texlive-core
		 dev-texlive/texlive-latex )
	wmf? ( >=media-libs/libwmf-0.2.2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	if ! use tools; then
		sed -i -e '/bin_/d' GNUmakefile.am || die
		sed -i -e '/SUBDIRS/d' GNUmakefile.am || die
		sed -i -e '/\/GNUmakefile/d' configure.ac || die
		sed -i -e '/wv[[:upper:]]/d' configure.ac || die

		# automake-1.13 fix, bug #467620
		sed -i -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' configure.ac || die

		eautoreconf
	fi
}

src_configure() {
	econf $(use_with wmf libwmf)
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/libwv-1.2.so.3
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/libwv-1.2.so.3
}

src_install () {
	emake DESTDIR="${D}" install || die "Installation failed"
	dodoc README NEWS || die

	rm -f "${ED}"/usr/share/man/man1/wvConvert.1
	if use tools; then
		dosym  /usr/share/man/man1/wvWare.1 /usr/share/man/man1/wvConvert.1 || die
	fi
}
