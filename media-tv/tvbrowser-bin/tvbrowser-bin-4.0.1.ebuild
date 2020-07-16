# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit desktop

MY_PN="tvbrowser"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Themeable and easy to use TV Guide - written in Java"
HOMEPAGE="https://www.tvbrowser.org"
SRC_URI="mirror://sourceforge/project/tvbrowser/TV-Browser%20Releases%20%28Java%208%20and%20higher%29/${PV}/${MY_PN}_${PV}_bin.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/jdk:1.8"

S="${WORKDIR}"/"${MY_P}"

src_install() {
	# Copy files and directories
	insinto /opt/"${P}"
	doins -r *

	# Generate launcher
	exeinto /opt/bin
	newexe - tvbrowser <<-_EOF_
		#!/bin/bash
		export JAVA_OPTS="\${JAVA_OPTS} -Dpropertiesfile=/opt/${P}/linux.properties"
		exec /bin/bash /opt/${P}/tvbrowser.sh "\$@"
	_EOF_

	# Generate desktop entry
	make_desktop_entry tvbrowser "TV-Browser" \
		/opt/"${P}"/imgs/tvbrowser128.png \
		"AudioVideo;TV;Video"
}
