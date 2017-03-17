# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN}-api"
MY_PV="11112001"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="XML:DB Java library"
HOMEPAGE="https://sourceforge.net/projects/xmldb-org/"
SRC_URI="mirror://sourceforge/xmldb-org/${MY_P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

CDEPEND="
	dev-java/xalan:0
	dev-java/xerces:2"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

S="${WORKDIR}/${PN}"

JAVA_GENTOO_CLASSPATH="
	xalan
	xerces-2
"

PATCHES=(
	"${FILESDIR}/${P}-enum.patch"
	"${FILESDIR}/${P}-unreachable.patch"
)

src_prepare() {
	default
	java-pkg_clean
	# Must hard-depend on dev-java/junit otherwise.
	rm -rv org/xmldb/api/tests || die
}
