# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="fast and light Scheme implementation"
HOMEPAGE="https://www.stklos.net/"
SRC_URI="https://www.${PN}.net/download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="threads"

RDEPEND="dev-libs/boehm-gc[threads?]
	dev-libs/gmp:=
	dev-libs/libffi:=
	dev-libs/libpcre"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS PACKAGES-USED PORTING-NOTES README SUPPORTED-SRFIS )

src_prepare() {
	rm -rf {ffi,gc,gmp,pcre}

	default
}

src_configure() {
	econf \
		--enable-threads=$(usex threads pthreads none) \
		--without-gmp-light \
		--without-provided-ffi \
		--without-provided-gc \
		--without-provided-regexp
}

src_compile() {
	emake -j1
}

src_test() {
	emake -j1 check
}

src_install() {
	default
	einstalldocs
}
