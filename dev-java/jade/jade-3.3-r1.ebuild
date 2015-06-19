# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jade/jade-3.3-r1.ebuild,v 1.4 2007/10/24 06:53:08 nelchael Exp $

JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-nodeps"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JADE is FIPA-compliant Java Agent Development Environment"
SRC_URI="mirror://gentoo/JADE-src-${PV}.zip"
HOMEPAGE="http://jade.cselt.it/"
IUSE=""
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

S="${WORKDIR}/${PN}"

EANT_BUILD_TARGET="clean lib"
EANT_DOC_TARGET="doc"

src_install() {
	java-pkg_dojar lib/*.jar
	dodoc README ChangeLog
	use doc && java-pkg_dojavadoc doc/
	use source && java-pkg_dosrc src/FIPA src/jade src/starlight
}
