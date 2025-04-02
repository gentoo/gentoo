# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils xdg

DESCRIPTION="Plot parametric and implicit surfaces"
HOMEPAGE="https://github.com/parisolab/mathmod
	https://sourceforge.net/projects/mathmod/
	https://www.facebook.com/parisolab"
SRC_URI="https://github.com/parisolab/mathmod/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-qt/qtbase:6[gui,opengl,widgets]
"
DEPEND="${RDEPEND}"

PATCHES=(
	# Fix collision between <complex.h> and QT
	# Merged, to be removed with release 12.1
	"${FILESDIR}"/${P}-rm_complex.patch
)

src_configure() {
	eqmake6 MathMod.pro
}

src_install() {
	dobin MathMod
	insinto /usr/share/${P}
	doins mathmodconfig.js mathmodcollection.js advancedmodels.js
	local size
	for size in 16 32 64; do
		newicon -s ${size} images/icon/catenoid_mini_${size}x${size}.png catenoid.png
	done
	make_desktop_entry MathMod MathMod catenoid
}
