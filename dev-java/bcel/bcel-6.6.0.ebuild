# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/commons/bcel/source/bcel-6.6.0-src.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris" --ebuild bcel-6.6.0.ebuild

EAPI=8

# No tests, junit-jupiter is not packaged
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.bcel:bcel:6.6.0"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Apache Commons Bytecode Engineering Library"
HOMEPAGE="https://commons.apache.org/proper/commons-bcel/"
SRC_URI="mirror://apache/commons/${PN}/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/bcel/source/bcel-${PV}-src.tar.gz.asc )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# Common dependencies
# POM: pom.xml
# org.apache.commons:commons-lang3:3.12.0 -> >=dev-java/commons-lang-3.12.0:3.6

CP_DEPEND="
	dev-java/commons-lang:3.6
"

# Compile dependencies
# POM: pom.xml
# test? javax:javaee-api:6.0 -> !!!groupId-not-found!!!
# test? net.java.dev.jna:jna:5.12.1 -> !!!suitable-mavenVersion-not-found!!!
# test? net.java.dev.jna:jna-platform:5.12.1 -> !!!artifactId-not-found!!!
# test? org.apache.commons:commons-exec:1.3 -> !!!artifactId-not-found!!!
# test? org.junit.jupiter:junit-jupiter:5.9.1 -> !!!groupId-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-apache-commons )
"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/commons.apache.org.asc"

DOCS=( NOTICE.txt RELEASE-NOTES.txt )

S="${WORKDIR}/${P}-src"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.bcel"
JAVA_SRC_DIR="src/main/java"
