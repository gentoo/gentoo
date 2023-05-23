# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.osgi:org.osgi.service.subsystem:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OSGi Companion Code for org.osgi.service.subsystem"
HOMEPAGE="https://www.osgi.org/"
SRC_URI="https://repo1.maven.org/maven2/org/osgi/org.${PN//-/.}/${PV}/org.${PN//-/.}-${PV}-sources.jar -> ${P}-sources.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip"

CP_DEPEND="
	dev-java/osgi-annotation:0
	dev-java/osgi-core:0
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*
"
