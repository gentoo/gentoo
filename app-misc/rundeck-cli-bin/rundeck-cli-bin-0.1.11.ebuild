# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="rundeck-cli"
MY_P="rundeck-cli-${PV}"

inherit java-pkg-2

DESCRIPTION="Command line tool for rundeck"
HOMEPAGE="http://rundeck.org"
SRC_URI="https://github.com/rundeck/${MY_PN}/releases/download/v${PV}/${MY_P}-all.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.8"

S="${WORKDIR}"

src_install() {
	java-pkg_newjar "${DISTDIR}"/${MY_P}-all.jar ${MY_PN}.jar
	java-pkg_dolauncher rd
}
