# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Metapackage for all components for a full-featured gEDA/gaf system"
HOMEPAGE="http://www.geda.seul.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sci-electronics/geda
	sci-electronics/gerbv
	>=sci-electronics/gnucap-0.35.20091207
	sci-electronics/pcb
	>=sci-electronics/iverilog-0.9.6
	sci-electronics/ngspice
	sci-electronics/gspiceui
	>=sci-electronics/gnetman-0.0.1_pre20110124
	sci-electronics/gtkwave
"
