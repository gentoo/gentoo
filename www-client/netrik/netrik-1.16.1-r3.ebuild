# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A text based web browser with no ssl support"
HOMEPAGE="http://netrik.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"

RDEPEND=">=sys-libs/ncurses-5.1:=[unicode(+)]
	sys-libs/readline:="
DEPEND="${RDEPEND}"

PATCHES=(
	# bug #459660
	"${FILESDIR}"/${P}-ncurses-tinfo.patch
	"${FILESDIR}"/${P}-configure.patch
)

src_prepare() {
	default

	sed -i -e "/^doc_DATA/s/COPYING LICENSE //" \
		Makefile.am || die 'sed on Makefile.am failed'

	# bug #467812
	sed -i -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' \
		configure.ac || die 'sed on configure.ac failed'

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" docdir="${EPREFIX}"/usr/share/doc/${PF} install
}
