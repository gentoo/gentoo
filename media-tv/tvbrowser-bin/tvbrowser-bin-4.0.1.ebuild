# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils desktop

DESCRIPTION="Themeable and easy to use TV Guide - written in Java"
HOMEPAGE="http://www.tvbrowser.org"
MY_PN="tvbrowser"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://sourceforge/project/tvbrowser/TV-Browser%20Releases%20%28Java%208%20and%20higher%29/${PV}/${MY_PN}_${PV}_bin.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/jdk:1.8"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/"${MY_P}"

generate_launcher() {
	echo "#!/bin/bash"
	echo "export JAVA_OPTS=\"\${JAVA_OPTS} -Dpropertiesfile=/opt/${P}/linux.properties\""
	echo "/bin/bash /opt/${P}/tvbrowser.sh"
}

src_install()
{
	# Copy files and directories
	cd "${S}"
	dodir /opt/"${P}"
	insinto /opt/"${P}"
	doins -r *

	# Generate launcher
	local tvbrowser_bin="tvbrowser"
	generate_launcher > "${tvbrowser_bin}"
	dobin "${tvbrowser_bin}"

	# Generate desktop entry
	make_desktop_entry "${tvbrowser_bin}" "TV-Browser" \
		/opt/"${P}"/imgs/tvbrowser128.png \
		"AudioVideo;TV;Video"
}
