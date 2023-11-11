# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="net.jacksum:jacksum:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java utility for working with checksums, CRCs, and message digests (hashes)"
HOMEPAGE="https://jacksum.net"
SRC_URI="https://github.com/jonelo/jacksum/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-11:*"

DOCS=(
	CODE_OF_CONDUCT.md
	PRE-RELEASE-NOTES
	README.md
	RELEASE-NOTES.txt
)

JAVA_MAIN_CLASS="net.jacksum.cli.Main"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
