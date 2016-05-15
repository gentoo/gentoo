# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="A Java-based framework to build multiplatform mail and messaging applications"
HOMEPAGE="http://java.sun.com/products/javamail/index.html"

# error 500 without the double slash, wonder what HTTP standard says about this
SRC_URI="http://kenai.com/projects/javamail/downloads/download//javamail-${PV}-src.zip"

# either of these
LICENSE="CDDL GPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

COMMON_DEP="java-virtuals/jaf"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S="${WORKDIR}"

# some not essential classes need 1.5 to compile
# but 1.4 bytecode for better support
JAVA_PKG_WANT_SOURCE="1.4"
JAVA_PKG_WANT_TARGET="1.4"

src_unpack() {
	default

	# build.xml expects it here
	mkdir -p legal/src/main/resources/META-INF || die
	cp mail/src/main/resources/META-INF/LICENSE.txt \
		legal/src/main/resources/META-INF || die
}

java_prepare() {
	java-pkg_jar-from --virtual jaf
}

EANT_DOC_TARGET="docs"
EANT_EXTRA_ARGS="-Djavaee.jar=activation.jar -Dspec.dir=doc/spec"

src_install() {
	java-pkg_dojar target/release/mail.jar

	dodoc doc/release/{CHANGES,COMPAT,NOTES,README,SSLNOTES,distributionREADME}.txt || die
	dohtml -r doc/release/{*.html,images} || die

	use doc && java-pkg_dojavadoc target/release/docs/javadocs
	use source && java-pkg_dosrc mail/src/main/java
}
