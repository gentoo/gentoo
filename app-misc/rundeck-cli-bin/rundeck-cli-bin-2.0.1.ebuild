# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Command line tool for rundeck"
HOMEPAGE="https://www.rundeck.com/open-source"
SRC_URI="https://github.com/rundeck/rundeck-cli/releases/download/v${PV}/rundeck-cli-${PV}-all.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+binary"

RDEPEND=">=virtual/jre-11:*"

JAVA_MAIN_CLASS="org.rundeck.client.tool.Main"
JAVA_BINJAR_FILENAME="rundeck-cli-${PV}-all.jar"
