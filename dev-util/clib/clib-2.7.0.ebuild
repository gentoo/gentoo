# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Package manager for the C programming language."
HOMEPAGE="https://www.clibs.org/"
SRC_URI="https://github.com/clibs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-misc/curl
	sys-libs/glibc
	net-libs/nghttp2
	dev-libs/openssl
	sys-libs/zlib"
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	emake || die "emake failed"
}

src_test () {
	emake test
}

src_install() {
	emake PREFIX="${D}" install || die "emake install failed"
	dodoc Readme.md LICENSE BEST_PRACTICE.md History.md
}

pkg_postinst() {
	elog "1. You could read some documents:"
	elog "     BEST_PRACTICE.md and Readme.md..."
	elog "   at /usr/share/doc/${P}/"
	elog "2. You also could view our wiki at:"
	elog "     https://github.com/clibs/clib/wiki"
	elog "3. Clib Website: https://www.clibs.org/"
}
