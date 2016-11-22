# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="QEmacs is a very small but powerful UNIX editor"
HOMEPAGE="https://savannah.nongnu.org/projects/qemacs"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="LGPL-2.1+ GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~ppc x86"
IUSE="X png unicode xv"
RESTRICT="test"

RDEPEND="
	X? ( x11-libs/libX11
		x11-libs/libXext
		xv? ( x11-libs/libXv ) )
	png? ( >=media-libs/libpng-1.2:0= )"

DEPEND="${RDEPEND}
	>=app-text/texi2html-5"

S="${WORKDIR}/${PN}"

src_prepare() {
	# Removes forced march setting and align-functions on x86, as they
	# would override user's CFLAGS..
	epatch "${FILESDIR}/${PN}-0.4.0_pre20080605-Makefile.patch"
	# Make backup files optional
	epatch "${FILESDIR}/${PN}-0.4.0_pre20080605-make_backup.patch"
	# Suppress stripping
	epatch "${FILESDIR}/${P}-nostrip.patch"

	use unicode && epatch "${FILESDIR}/${PN}-0.3.2_pre20070226-tty_utf8.patch"

	# Change the manpage to reference a /real/ file instead of just an
	# approximation.  Purely cosmetic!
	sed -i -e "s,^/usr/share/doc/qemacs,&-${PVR}," qe.1 || die

	# Fix compability with >=app-text/texi2html-5
	sed -i -e "/texi2html/s,-number,&-sections," Makefile || die
}

src_configure() {
	# when using any other CFLAGS than -O0, qemacs will segfault on startup,
	# see bug 92011
	replace-flags "-O?" -O0
	econf --cc="$(tc-getCC)" \
		$(use_enable X x11) \
		$(use_enable png) \
		$(use_enable xv)
}

src_compile() {
	# Does not support parallel building.
	emake -j1
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc Changelog README TODO config.eg
	dohtml *.html

	# Fix man page location
	mv "${D}"/usr/{,share/}man || die

	# Install headers so users can build their own plugins.
	insinto /usr/include/qe
	doins *.h
	insinto /usr/include/qe/libqhtml
	doins libqhtml/*.h
}
