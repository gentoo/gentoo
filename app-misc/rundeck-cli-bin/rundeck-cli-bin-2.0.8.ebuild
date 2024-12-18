# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="Command line tool for rundeck"
HOMEPAGE="https://www.rundeck.com"
SRC_URI="https://github.com/rundeck/rundeck-cli/releases/download/v${PV}/rundeck-cli-${PV}-all.jar"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-11:*"

src_install() {
	java-pkg_newjar "${DISTDIR}"/rundeck-cli-${PV}-all.jar rundeck-cli.jar
	java-pkg_dolauncher rd
}
