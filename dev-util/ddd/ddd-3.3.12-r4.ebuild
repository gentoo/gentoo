# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools eutils

DESCRIPTION="Graphical front-end for command-line debuggers"
HOMEPAGE="https://www.gnu.org/software/ddd"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3 FDL-1.1"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="readline"

COMMON_DEPEND="
	sys-devel/gdb
	sys-libs/ncurses:*
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	>=x11-libs/motif-2.3:0
	ppc? ( dev-libs/elfutils )
	ppc64? ( dev-libs/elfutils )
	readline? ( sys-libs/readline:* )
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"
RDEPEND="${COMMON_DEPEND}
	x11-apps/xfontsel
"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${P}-gcc44.patch"
	"${FILESDIR}/${P}-gdb-disassembler-bug.patch"
	"${FILESDIR}/${PN}-3.3.12-man.patch"
	"${FILESDIR}/${PN}-3.3.12-tinfo.patch"
	"${FILESDIR}/${PN}-3.3.12-gcc9.patch"
	"${FILESDIR}/${PN}-3.3.12-parallel.patch"
)

DOCS=(
	AUTHORS CREDITS INSTALL NEWS PROBLEMS README TIPS TODO
	doc/ddd{-paper.ps,.pdf,-themes.pdf}
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_with readline)
}

src_install() {
	# Remove app defaults
	rm -f "${S}"/ddd/Ddd

	# Install ddd distribution
	default

	# Install application icon
	doicon "${S}"/icons/ddd.xpm
}

pkg_postinst() {
	if ! has_version sci-visualization/gnuplot; then
		echo
		elog "To enable data visualization in DDD, install sci-visualization/gnuplot."
		elog "For flat file package.use layout:"
		elog "   echo '${CATEGORY}/${PN} gnuplot' >> /etc/portage/package.use && emerge -va gnuplot"
		elog "For directory package.use layout:"
		elog "   echo '${CATEGORY}/${PN} gnuplot' > /etc/portage/package.use/ddd && emerge -va gnuplot"
		elog
	fi
	echo
	elog "Important notice: if you encounter DDD crashes during visualization, you might"
	elog "have hit bug #459324. Try switching to plotting in external window:"
	elog "Select Edit|Preferences|Helpers and switch 'plot window' to 'external'"
	elog
	elog "To be able to debug java, bash, perl or python scripts within DDD, install respectively:"
	elog "    virtual/jdk"
	elog "    app-shells/bashdb"
	elog "    dev-lang/perl"
	elog "    dev-python/pydb"
	echo
}
