# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="J2EE Application Deployment Specification V.1.2"
HOMEPAGE="https://glassfish.dev.java.net/"
SRC_URI="https://repo1.maven.org/maven2/org/glassfish/javax.enterprise.deploy/${PV}/javax.enterprise.deploy-${PV}-sources.jar -> ${P}.jar"

LICENSE="|| ( CDDL GPL-2 )"
SLOT="1.2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=virtual/jdk-1.6"

RDEPEND="
	>=virtual/jre-1.6"
