# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools toolchain-funcs

DESCRIPTION="Fast and light Scheme implementation"
HOMEPAGE="https://stklos.net/"
SRC_URI="https://${PN}.net/download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="threads"

RDEPEND="dev-libs/boehm-gc[threads?]
	dev-libs/gmp:=
	dev-libs/libffi:=
	dev-libs/libpcre2:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-ldflags.patch
)
DOCS=( AUTHORS ChangeLog NEWS.md PACKAGES-USED {PORTING-NOTES,README}.md SUPPORTED-SRFIS )

src_prepare() {
	default

	if ! use threads; then
		sed -i '/threads.adoc/d' doc/refman/${PN}.adoc
		rm -f tests/srfis/2{16,30}.stk
	fi
	eautoreconf
	export LD="$(tc-getCC)"
	export STKLOS_CONFDIR="${T}"/.config/${PN}
}

src_configure() {
	econf \
		--enable-threads=$(usex threads pthreads none) \
		--without-provided-bignum \
		--without-provided-ffi \
		--without-provided-gc \
		--without-provided-regexp
}

src_compile() {
	emake
}

src_test() {
	emake -j1 check
}

src_install() {
	default
	einstalldocs
}
