# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Graphical IDE for microcontrollers based on 8051."
HOMEPAGE="http://www.moravia-microsystems.com/mcu-8051-ide/"
SRC_URI="http://www.moravia-microsystems.com/download/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

# The doxygen dependency is suspect, but it appears to be used at runtime.
RDEPEND=">=dev-embedded/sdcc-2.5[mcs51]
		>=app-doc/doxygen-1.7
		>=dev-util/indent-2.2
		>=app-text/hunspell-1.3
		>=dev-tcltk/bwidget-1.8
		>dev-tcltk/itcl-3.3
		>=dev-lang/tcl-8.5.9:*
		>=dev-tcltk/tdom-0.8
		>=dev-tcltk/tcllib-1.11
		>=dev-lang/tk-8.5.9:*
		>=dev-tcltk/tkimg-1.4
		>=dev-tcltk/tclx-8.4"
DEPEND="${RDEPEND}"
