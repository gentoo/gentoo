# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/optipng/optipng-0.7.3.ebuild,v 1.4 2012/09/22 02:20:19 blueness Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="Compress PNG files without affecting image quality"
HOMEPAGE="http://optipng.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="sys-libs/zlib
	media-libs/libpng:0"
DEPEND="${RDEPEND}
	sys-apps/findutils"

src_prepare() {
	rm -R src/{libpng,zlib} || die
	find . -type d -name build -exec rm -R {} + || die

	# next release is almost a complete rewrite, so plug this compilation
	# problem in anticipation of the much (c)leaner(?) rewrite
	sed -i \
		-e 's/^#ifdef AT_FDCWD/#if defined(AT_FDCWD) \&\& !(defined (__SVR4) \&\& defined (__sun))/' \
		src/optipng/osys.c || die
}

src_configure() {
	./configure \
		-with-system-libpng \
		-with-system-zlib \
		|| die "configure failed"
}

src_compile() {
	emake \
		-C src/optipng \
		CC="$(tc-getCC)" \
		GENTOO_CFLAGS="${CFLAGS}" \
		GENTOO_LDFLAGS="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dodoc README.txt doc/*.txt || die
	dohtml doc/*.html || die
	doman src/optipng/man/optipng.1 || die

	dobin src/optipng/optipng || die "dobin failed"
}
