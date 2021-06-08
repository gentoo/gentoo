# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV="VERSION_${PV//./_}"
DESCRIPTION="Markdown translator producing HTML5, roff documents in the ms and man formats"
HOMEPAGE="https://kristaps.bsd.lv/lowdown/"
SRC_URI="https://github.com/kristapsdz/lowdown/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	virtual/libcrypt
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/lowdown-0.8.4-configure.patch"
)

src_configure() {
	CC="$(tc-getCC)" ./configure || die "./configure failed"
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}" AR="$(tc-getAR)" $(usex elibc_musl UTF8_LOCALE=C.UTF-8 '')
}

src_test() {
	emake regress
}
