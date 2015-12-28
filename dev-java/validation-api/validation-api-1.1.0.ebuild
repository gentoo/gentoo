# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Bean Validation (JSR-303) API"
HOMEPAGE="http://fisheye.jboss.org/browse/Hibernate/beanvalidation/api/tags/v1_0_0_GA"
SRC_URI="https://repo1.maven.org/maven2/javax/validation/${PN}/${PV}.Final/${P}.Final-sources.jar -> ${P}.jar"

LICENSE="Apache-2.0"
SLOT="1.0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"
