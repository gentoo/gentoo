# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic

DESCRIPTION="A flexible command-line scientific calculator"
HOMEPAGE="http://w-calc.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/w-calc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 ~x86"
IUSE="readline"

RDEPEND="
	dev-libs/gmp:0=
	dev-libs/mpfr:0=
	readline? ( sys-libs/readline:0= )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-AR.patch
	"${FILESDIR}"/0001-fix-bashism-in-configure-script.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/862384
	#
	# Upstream is sourceforge. Last release in 2015, last activity 2021. Not
	# submitting a bug report for now. -- Eli
	filter-lto

	econf $(use_with readline)
}

src_install() {
	default

	# Wcalc icons
	newicon graphics/w.png wcalc.png
	newicon graphics/Wred.png wcalc-red.png
}
