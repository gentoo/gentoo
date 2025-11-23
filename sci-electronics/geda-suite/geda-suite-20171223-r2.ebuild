# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

HOMEPAGE="http://www.geda.seul.org"
DESCRIPTION="Metapackage for all components for a full-featured gEDA/gaf system"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="
	sci-electronics/geda
	sci-electronics/gerbv
	>=sci-electronics/gnucap-0.35.20091207
	>=sci-electronics/gwave-20090213-r1
	sci-electronics/pcb
	>=sci-electronics/iverilog-0.9.6
	sci-electronics/ngspice
	sci-electronics/gspiceui
	>=sci-electronics/gnetman-0.0.1_pre20110124
	sci-electronics/gtkwave
"
