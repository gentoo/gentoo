# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Command-line RSS feed reader"
HOMEPAGE="https://github.com/msharov/snownews"
SRC_URI="https://github.com/msharov/snownews/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	dev-libs/libxml2
	dev-libs/openssl:=
	net-misc/curl
	sys-libs/ncurses:=[unicode(+)]
"

DEPEND="${RDEPEND}"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9-no-which.patch
)

src_prepare() {
	default

	tc-export CC

	# Disable stripping in the build system - leave it to the package manager
	sed -i -e '/ldflags/s/-s/-g -rdynamic/' -e '/cflags/s/-g0/-g/' Config.mk.in || die
}

src_configure() {
	econf "$(use_with debug)"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}
