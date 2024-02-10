# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Connect stdin and stdout to a server via an HTTPS proxy"
HOMEPAGE="https://github.com/proxytunnel/proxytunnel/ https://proxytunnel.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="static"

RDEPEND="dev-libs/openssl:="
DEPEND="${RDEPEND}
	app-text/asciidoc
	app-text/xmlto
	"
BDEPEND="virtual/pkgconfig"

DOCS=( CHANGES CREDITS INSTALL.md KNOWN_ISSUES LICENSE.txt README.md RELNOTES TODO )

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
fi

src_prepare() {
	default
	sed -i -e 's/libssl/libssl libcrypto/' Makefile || die "Sed failed!"
}

src_compile() {
	use static && append-ldflags -static
	emake CC="$(tc-getCC)"
}

src_install() {
	emake install prefix="${EPREFIX}"/usr DESTDIR="${D}"
	einstalldocs
}
