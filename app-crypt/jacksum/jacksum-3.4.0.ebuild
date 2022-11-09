# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java utility for working with checksums, CRCs, and message digests (hashes)"
HOMEPAGE="https://jacksum.net"
SRC_URI="https://github.com/jonelo/jacksum/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=(
	CODE_OF_CONDUCT.md
	PRE-RELEASE-NOTES
	README.md
	RELEASE-NOTES.txt
)

S="${WORKDIR}/${P}"

JAVA_LAUNCHER_FILENAME="${PN}"
JAVA_MAIN_CLASS="net.jacksum.cli.Main"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
