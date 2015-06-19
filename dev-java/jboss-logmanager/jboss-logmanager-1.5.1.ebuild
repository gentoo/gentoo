# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jboss-logmanager/jboss-logmanager-1.5.1.ebuild,v 1.3 2015/05/21 08:26:09 ago Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JBoss logging framework"
HOMEPAGE="http://www.jboss.org/"
SRC_URI="https://github.com/${PN/logmanager/logging}/${PN}/archive/${PV}.Final.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="dev-java/jboss-modules:0"
RDEPEND=">=virtual/jre-1.5
		${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
		${CDEPEND}"

S="${WORKDIR}/${P}.Final/"

JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="jboss-modules"

java_prepare() {
	rm pom.xml || die
}
