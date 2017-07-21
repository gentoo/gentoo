# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit toolchain-funcs autotools python-single-r1 eutils

DESCRIPTION="WorldForge server running small games"
HOMEPAGE="http://worldforge.org/index.php/components/cyphesis/"
SRC_URI="mirror://sourceforge/worldforge/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	dev-db/postgresql:=
	>=dev-games/mercator-0.3.3
	>=dev-games/wfmath-1.0.1
	dev-libs/libgcrypt:0
	dev-libs/libsigc++:2
	sys-libs/ncurses:0
	sys-libs/readline:0
	>=media-libs/atlas-c++-0.6.3
	>=media-libs/skstream-0.3.9
	>=media-libs/varconf-0.6.4
	"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.40
	dev-libs/libxml2
	virtual/pkgconfig"

pkg_setup() {
	python-single-r1_pkg_setup
}

PATCHES=(
		"${FILESDIR}"/${P}-gentoo.patch
		"${FILESDIR}"/${P}-makefile.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf --localstatedir=/var
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	emake DESTDIR="${D}" confbackupdir="/usr/share/doc/${PF}/conf" install
	dodoc AUTHORS ChangeLog FIXME NEWS README THANKS TODO
}
