# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Compress PNG files without affecting image quality"
HOMEPAGE="http://optipng.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="sys-libs/zlib
	media-libs/libpng:0"
DEPEND="${RDEPEND}
	sys-apps/findutils"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.7.5-estonian.patch
	epatch "${FILESDIR}"/${PN}-0.7.6-cve-2017-1000229.patch  # bug 637936
	epatch "${FILESDIR}"/${PN}-0.7.6-cve-2017-16938.patch  # bug 639690

	rm -R src/{libpng,zlib} || die
	find . -type d -name build -exec rm -R {} + || die

	# next release is almost a complete rewrite, so plug this compilation
	# problem in anticipation of the much (c)leaner(?) rewrite
	sed -i \
		-e 's/^#ifdef AT_FDCWD/#if defined(AT_FDCWD) \&\& !(defined (__SVR4) \&\& defined (__sun))/' \
		src/optipng/osys.c || die

	tc-export CC AR RANLIB
	export LD=$(tc-getCC)

	eapply_user
}

src_configure() {
	./configure \
		-with-system-libpng \
		-with-system-zlib \
		|| die "configure failed"
}

src_compile() {
	emake -C src/optipng
}

src_install() {
	dodoc README.txt doc/*.txt
	dohtml doc/*.html
	doman src/${PN}/man/${PN}.1

	dobin src/${PN}/${PN}
}
