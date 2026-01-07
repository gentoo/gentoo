# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Compress PNG files without affecting image quality"
HOMEPAGE="https://optipng.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ppc ppc64 ~riscv x86"

RDEPEND="virtual/zlib:=
	media-libs/libpng:0="
DEPEND="${RDEPEND}"

DOCS=( AUTHORS.txt README.txt )

src_prepare() {
	rm -R third_party/{libpng,zlib} || die
	find . -type d -name build -exec rm -R {} + || die

	sed -i \
		-e 's/^#if defined AT_FDCWD/#if (defined(AT_FDCWD) \&\& !(defined(__SVR4) \&\& defined(__sun)))/' \
		src/optipng/ioutil.c || die

	tc-export CC AR RANLIB
	export LD="$(tc-getCC)"

	eapply_user
}

src_configure() {
	./configure \
		--with-system-libpng \
		--with-system-zlib \
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
