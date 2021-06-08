# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit desktop

DESCRIPTION="Themeable and easy to use TV Guide - written in Java"
HOMEPAGE="https://www.tvbrowser.org"
MY_PN="tvbrowser"
SRC_URI="mirror://sourceforge/project/tvbrowser/TV-Browser%20Releases%20%28Java%2011%20and%20higher%29/${PV}/${MY_PN}_${PV}_bin.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

JAVA_SLOT=11
RDEPEND="|| ( dev-java/openjdk:${JAVA_SLOT}
	dev-java/openjdk-bin:${JAVA_SLOT}
	dev-java/openjdk-jre-bin:${JAVA_SLOT} )"

S="${WORKDIR}"/"${MY_PN}-${PV}"

src_install() {
	# Copy files and directories
	insinto /opt/"${P}"
	doins -r *

	# Generate launcher
	exeinto /opt/bin
	sed -e "s/^P=.*\$/P=${P}/" \
		-e "s/^JAVA_SLOT=.*\$/JAVA_SLOT=${JAVA_SLOT}/" \
		"${FILESDIR}"/tvbrowser | \
		newexe - tvbrowser || die

	# Generate desktop entry
	make_desktop_entry tvbrowser "TV-Browser" \
		/opt/"${P}"/imgs/tvbrowser128.png \
		"AudioVideo;TV;Video"
}
