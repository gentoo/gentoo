# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_REQ_USE="deprecated"
GUILE_COMPAT=( 2-2 3-0 )
inherit autotools guile-single

DESCRIPTION="Tool for launching commands on keystrokes"
SRC_URI="https://www.nongnu.org/${PN}/${P}.tar.gz"
HOMEPAGE="https://www.nongnu.org/xbindkeys/xbindkeys.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 ~riscv ~sparc x86"
IUSE="guile tk"

REQUIRED_USE="guile? ( ${GUILE_REQUIRED_USE} )"

RDEPEND="
	x11-libs/libX11
	guile? ( ${GUILE_DEPS} )
	tk? ( dev-lang/tk )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

DOCS=( AUTHORS BUGS ChangeLog README TODO xbindkeysrc )

pkg_setup() {
	use guile && guile-single_pkg_setup
}

src_prepare() {
	default

	use guile && guile_bump_sources

	# Regenerate to pick up newer versions of Guile macros
	# bug #828532
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable guile) \
		$(use_enable tk)
}

src_install() {
	default

	use guile && guile_unstrip_ccache
}
