# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Text mode (ncurses) SMB network commander. Features: resume and UTF-8"
HOMEPAGE="https://sourceforge.net/projects/smbc/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls debug"

BDEPEND="virtual/pkgconfig"
DEPEND="dev-libs/popt
	net-fs/samba
	sys-libs/ncurses
	nls? ( sys-devel/gettext )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-size_t.patch
	"${FILESDIR}"/${P}-samba4-includes.patch
	"${FILESDIR}"/${P}-multiple-definitions-gcc10.patch
	"${FILESDIR}"/${P}-tinfo.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	# for some reason some build 32bit x86 objects are bundled
	rm src/*.o
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with debug)
}

src_install() {
	default
	mkdir -p "${D}/usr/share/doc"
	mv -v "${D}/usr/share/"{${PN},doc/${PF}} || die
}
