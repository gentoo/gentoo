# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library that implements the CIFS/SMB networking protocol in Java"
SRC_URI="https://jcifs.samba.org/src/${P}.tgz"
HOMEPAGE="https://jcifs.samba.org/"
LICENSE="LGPL-2.1"
SLOT="1.1"

KEYWORDS="~amd64 ~ppc64 ~x86"

CDEPEND="java-virtuals/servlet-api:3.0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

JAVA_GENTOO_CLASSPATH="servlet-api-3.0"

JAVA_SRC_DIR="src"

DOCS=( README.txt )

S="${WORKDIR}/${P/-/_}"

src_prepare() {
	default
	java-pkg_clean
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples examples
	einstalldocs
}
