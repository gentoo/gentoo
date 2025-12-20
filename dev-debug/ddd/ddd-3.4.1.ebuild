# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop flag-o-matic optfeature

DESCRIPTION="Graphical front-end for command-line debuggers"
HOMEPAGE="https://www.gnu.org/software/ddd"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 ~sparc x86"
IUSE="readline"

RESTRICT="test"

COMMON_DEPEND="
	dev-debug/gdb
	media-libs/freetype:2
	sys-libs/ncurses:=
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	>=x11-libs/motif-2.3:0
	ppc? ( dev-libs/elfutils )
	ppc64? ( dev-libs/elfutils )
	readline? ( sys-libs/readline:= )
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"
RDEPEND="${COMMON_DEPEND}
	x11-apps/xfontsel
"

DOCS=(
	README doc/ddd{.pdf,-themes.pdf}
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/858347
	# https://savannah.gnu.org/bugs/?65456
	filter-lto

	econf \
		$(use_with readline)
}

src_install() {
	# Remove app defaults
	rm -f "${S}"/ddd/Ddd || die

	# Install ddd distribution
	default

	# Install application icon
	doicon "${S}"/icons/ddd.xpm
}

pkg_postinst() {
	optfeature "Data visualisation" sci-visualization/gnuplot
	optfeature "Java debugging" virtual/jdk
	optfeature "Bash debugging" app-shells/bashdb
	optfeature "Perl debugging" dev-lang/perl
	optfeature "Python debugging" dev-python/pydb
	elog
	elog "Important notice: if you encounter DDD crashes during visualization, you might"
	elog "have hit bug #459324. Try switching to plotting in external window:"
	elog "Select Edit|Preferences|Helpers and switch 'plot window' to 'external'"
}
