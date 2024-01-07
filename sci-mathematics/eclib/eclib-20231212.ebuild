# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Programs for elliptic curves defined over the rational numbers"
HOMEPAGE="https://github.com/JohnCremona/eclib"
SRC_URI="https://github.com/JohnCremona/${PN}/releases/download/v${PV}/${P}.tar.bz2"

# COPYING is GPL-2 but the file headers say "or ... any later version"
# LGPL-2.1+ is for bundled GetOpt.cc
LICENSE="GPL-2+ LGPL-2.1+"

# Subslot is from the soname, (LT_CURRENT - LT_AGE) in configure.ac.
# (But for now, see src_prepare below.)
SLOT="0/12"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="boost flint minimal test"
RESTRICT="!test? ( test )"

RDEPEND="sci-mathematics/pari:=
	dev-libs/ntl:=
	boost? ( dev-libs/boost:= )
	flint? ( sci-mathematics/flint:= )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	# LT_CURRENT was bumped to 12 in the 20230424 release but LT_AGE was
	# left at two despite an interface being removed. Subsequent releases
	# have propagated the off-by-two error. This isn't strictly necessary
	# but it's nice to have the soname match the subslot.
	sed -e 's/LT_AGE=3/LT_AGE=1/' -i configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(usex minimal --disable-allprogs "" "" "") \
		$(use_with boost) \
		$(use_with flint)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
