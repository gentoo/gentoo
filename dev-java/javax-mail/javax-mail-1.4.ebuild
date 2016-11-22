# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Provides a platform/protocol-independent framework for mail and messaging apps"
HOMEPAGE="https://javamail.java.net/"
SRC_URI="http://repo1.maven.org/maven2/javax/mail/mail/${PV}/mail-${PV}-sources.jar"

LICENSE="|| ( CDDL GPL-2-with-classpath-exception )"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

IUSE=""

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"
DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	app-arch/unzip"
