# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE=""

inherit java-pkg-2

DESCRIPTION="High Energy Physics Java library"
HOMEPAGE="http://java.freehep.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_URI="http://java.freehep.org/maven2/org/netbeans/openide-lookup/1.9-patched-1.0/openide-lookup-1.9-patched-1.0.jar
	http://java.freehep.org/maven2/org/freehep/jas-plotter/2.2.3/jas-plotter-2.2.3.jar
	http://java.freehep.org/maven2/hep/aida/aida/3.3/aida-3.3.jar
	http://java.freehep.org/maven2/hep/testdata/hbook/JAS/1.0/JAS-1.0.hbook
	http://java.freehep.org/maven2/hep/testdata/hbook/pawdemo/1.0/pawdemo-1.0.hbook
	http://java.freehep.org/maven2/hep/testdata/hbook/rowwise/1.0/rowwise-1.0.hbook"

COMMON_DEP=""
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
JAVA_GENTOO_CLASSPATH=""

src_install() {
	java-pkg_dojar "${DISTDIR}/openide-lookup-1.9-patched-1.0.jar"
	java-pkg_regjar "/usr/share/${PN}/lib/openide-lookup-1.9-patched-1.0.jar"
	java-pkg_dojar "${DISTDIR}/jas-plotter-2.2.3.jar"
	java-pkg_regjar "/usr/share/${PN}/lib/jas-plotter-2.2.3.jar"
	java-pkg_dojar "${DISTDIR}/aida-3.3.jar"
	java-pkg_regjar "/usr/share/${PN}/lib/aida-3.3.jar"
	insinto /usr/share/${PN}
	doins "${DISTDIR}/JAS-1.0.hbook"
	doins "${DISTDIR}/pawdemo-1.0.hbook"
	doins "${DISTDIR}/rowwise-1.0.hbook"
}
