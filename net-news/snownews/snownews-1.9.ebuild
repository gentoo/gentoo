# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit toolchain-funcs

DESCRIPTION="Command-line RSS feed reader"
HOMEPAGE="https://github.com/msharov/snownews"
SRC_URI="https://github.com/msharov/snownews/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/libxml2-2.5.6
	sys-libs/ncurses:=[unicode(+)]
	dev-libs/openssl
	net-misc/curl
	sys-devel/gettext
"
RDEPEND="
	${COMMON_DEPEND}
"

DEPEND="
	${COMMON_DEPEND}
"

IUSE="debug"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	# Disable stripping in the build system - leave it to the package manager
	sed -i -e '/ldflags/-s/-g -rdynamic//' -e '/cflags/s/-g0/-g/' Config.mk.in || die
}

src_configure() {
	econf "$(use_with debug)"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}
