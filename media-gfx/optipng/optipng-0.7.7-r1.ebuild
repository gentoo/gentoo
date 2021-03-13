# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Compress PNG files without affecting image quality"
HOMEPAGE="http://optipng.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE=""

RDEPEND="sys-libs/zlib
	media-libs/libpng:0="
DEPEND="${RDEPEND}
	sys-apps/findutils"

DOCS=( AUTHORS.txt README.txt )

src_prepare() {
	rm -R src/{libpng,zlib} || die
	find . -type d -name build -exec rm -R {} + || die

	# next release is almost a complete rewrite, so plug this compilation
	# problem in anticipation of the much (c)leaner(?) rewrite
	sed -i \
		-e 's/^#if defined AT_FDCWD/#if (defined(AT_FDCWD) \&\& !(defined(__SVR4) \&\& defined(__sun)))/' \
		src/optipng/ioutil.c || die

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
	einstalldocs

	dodoc doc/*.txt
	docinto html
	dodoc doc/*.html
	doman src/${PN}/man/${PN}.1

	dobin src/${PN}/${PN}
}
