# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A language agnostic web server focused on web applications"
HOMEPAGE="http://mongrel2.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-db/sqlite:3
	>=net-libs/mbedtls-2.1[havege]
	net-libs/zeromq"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-polarssl-platform-590512.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	cp "${FILESDIR}"/systemtls.mak Makefile || die
	default
}

src_configure() {
	tc-export CC
	default
}

src_install() {
	emake PREFIX="${EPREFIX}"/usr DESTDIR="${D}" install
	dodoc README examples/configs/mongrel2.conf
}
