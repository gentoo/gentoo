# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Xerses Java Parser"
HOMEPAGE="https://xerces.apache.org/xerces-j"
SRC_URI="https://dev.gentoo.org/~monsieurp/packages/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1"

KEYWORDS="~amd64 ~arm ~ppc64 ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

CDEPEND="dev-java/ant-core:0"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.7"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.7"

JAVA_GENTOO_CLASSPATH="ant-core"
