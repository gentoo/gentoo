# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

HOMEPAGE="http://www.geda.seul.org"
DESCRIPTION="Metapackage for all components for a full-featured gEDA/gaf system"

IUSE=''
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="sci-electronics/geda
	sci-electronics/gerbv
	>=sci-electronics/gnucap-0.35.20091207
	>=sci-electronics/gwave-20090213-r1
	>=sci-electronics/pcb-20100929
	>=sci-electronics/geda-xgsch2pcb-0.1.3-r2
	>=sci-electronics/iverilog-0.9.1
	sci-electronics/ngspice
	sci-electronics/gspiceui
	>=sci-electronics/gnetman-0.0.1_pre20060522-r2
	sci-electronics/gtkwave"
