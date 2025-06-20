# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Additional colormaps for octave by Ultralytics"
HOMEPAGE="https://github.com/ultralytics/functions-matlab/tree/main/plotting/colormaps"
COMMIT="c9559c6511a6b43bb5037ee525dcd8d3abd7e087"
SRC_URI="https://github.com/ultralytics/functions-matlab/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN/-colormaps/}-${COMMIT}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="sci-mathematics/octave:="
BDEPEND="${RDEPEND}"

src_install() {
	insinto "$(octave-config --m-site-dir)"
	doins plotting/colormaps/*.m
}
