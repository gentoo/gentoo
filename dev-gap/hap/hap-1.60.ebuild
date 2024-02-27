# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Homological Algebra Programming (HAP) in GAP"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-gap/aclib
	dev-gap/crystcat
	dev-gap/fga
	dev-gap/nq
	dev-gap/polycyclic"

# Singular: https://docs.gap-system.org/pkg/hap/doc/chap14.html
# EDIM: https://docs.gap-system.org/pkg/hap/doc/chap11.html
# congruence is needed for ResolutionSL2Z()
# tst/testextra/3.6.1.tst calls LieAlgebra() from laguna
# EquivariantEuclideanSpace() in tst/testallV11/1.8.1.tst needs hapcryst
#
# The imagemagick "convert" utility is used in a few places, and it does
# actually need to be imagemagick (and not graphicsmagick) because e.g.
# ReadImageAsPureCubicalComplex parses the comment that only imagemagick
# puts at the top of a text file:
#
#   https://github.com/gap-packages/hap/issues/115
#
BDEPEND="test? (
	dev-gap/congruence
	dev-gap/edim
	dev-gap/hapcryst
	dev-gap/laguna
	dev-gap/polymaking
	dev-gap/singular
	media-gfx/imagemagick[png]
)"

HTML_DOCS="www/* tutorial"

GAP_PKG_EXTRA_INSTALL=( boolean )
gap-pkg_enable_tests

pkg_postinst() {
	elog "Some optional functions require media-gfx/graphviz"
	elog "to be installed at runtime."
}
