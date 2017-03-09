# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="A Plasmid Editor"
HOMEPAGE="http://www.biology.utah.edu/jorgensen/wayned/ape/"
SRC_URI="http://www.biology.utah.edu/jorgensen/wayned/ape/Download/Linux/ApE_linux_current.zip -> ${P}.zip"

LICENSE="ApE"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="
	dev-lang/tcl:0
	dev-lang/tk:0"

RESTRICT="mirror"

S="${WORKDIR}/ApE Linux/"

src_compile() { :; }

src_install() {
	cat >> "${T}/ApE" <<- "EOF"
	#!/bin/bash
	cmdArgs=""

	# AppMain.tcl searches files relative to the directory where it resides.
	# Add absolute path to file here, if necessary.
	for rfpath in "$@"; do
		afpath="$PWD/${rfpath}"
		if test -r "${afpath}"; then
			cmdArgs="${cmdArgs} \"${afpath}\"";
		else
			cmdArgs="${cmdArgs} \"${rfpath}\"";
		fi
	done

	eval exec tclsh "\"/usr/share/ApE-2.0.7/AppMain.tcl\"" "${cmdArgs}"
	EOF

	dobin "${T}/ApE"
	insinto "/usr/share/${P}"
	doins -r "${WORKDIR}"/ApE\ Linux/*
	make_desktop_entry ${PN} ${PN} \
		"/usr/share/${P}/Accessory Files/Icons and images/monkey_icon.gif" \
		"Science"
}
