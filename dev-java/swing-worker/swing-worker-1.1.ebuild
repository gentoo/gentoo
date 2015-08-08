# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java 1.6 SwingWorker backport for Java 1.5"
HOMEPAGE="https://swingworker.dev.java.net"
SRC_URI="https://swingworker.dev.java.net/files/documents/2810/51774/${PN}-src-${PV}.zip"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.5
		app-arch/unzip
		dev-java/ant-core"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}"

EANT_BUILD_TARGET="compile"

src_install() {
	use doc && java-pkg_dojavadoc dist/javadoc
	cd build
	jar cf "../${PN}.jar" * || die "Unable to create jar"
	cd ..
	java-pkg_dojar "${PN}.jar"

	use source && java-pkg_dosrc src/java/*
}
