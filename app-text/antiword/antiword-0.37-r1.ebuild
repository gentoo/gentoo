# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

IUSE="kde"
PATCHVER="r2"
DESCRIPTION="free MS Word reader"
HOMEPAGE="http://www.winfield.demon.nl"
SRC_URI="http://www.winfield.demon.nl/linux/${P}.tar.gz
	https://dev.gentoo.org/~grobian/distfiles/${PN}-gentoo-patches-${PATCHVER}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~arm ~hppa ppc ppc64 sparc x86 ~ppc-aix ~ia64-hpux ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

src_prepare() {
	# Makefile is a symlink to Makefile.Linux, avoid that we patch it by
	# accident using patch <2.7, see bug #435492
	rm Makefile || die

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/${PN}-gentoo-patches-${PATCHVER}"

	# Re-add convenience symlink, see above
	ln -s Makefile.Linux Makefile

	epatch "${FILESDIR}"/${P}-CVE-2014-8123.patch
}

src_configure() { :; }

src_compile() {
	emake PREFIX="${EPREFIX}" OPT="${CFLAGS}" CC="$(tc-getCC)" LD="$(tc-getCC)" \
		LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	emake -j1 PREFIX="${EPREFIX}" DESTDIR="${D}" global_install || die

	use kde || rm -f "${ED}"/usr/bin/kantiword

	insinto /usr/share/${PN}/examples
	doins Docs/testdoc.doc Docs/antiword.php || die

	cd Docs
	doman antiword.1 || die
	dodoc ChangeLog Exmh Emacs FAQ History Netscape QandA ReadMe Mozilla Mutt || die
}
