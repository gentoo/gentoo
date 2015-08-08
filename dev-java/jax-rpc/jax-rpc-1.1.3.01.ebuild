# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Reference Implementation of JAX-RPC, the Java APIs for XML based RPC"
HOMEPAGE="http://jax-rpc.dev.java.net/"
# CVS: cvs -d :pserver:guest@cvs.dev.java.net:/cvs checkout -r JAXRPC_1_1_3_01_PKG_081806 jax-rpc/jaxrpc-ri
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"

IUSE=""

COMMON_DEP="=dev-java/servletapi-2.4*
	dev-java/fastinfoset
	dev-java/jaxp
	dev-java/jsr67
	dev-java/jsr101
	dev-java/jsr173
	dev-java/relaxng-datatype
	dev-java/saaj
	dev-java/sax
	dev-java/sun-jaf
	dev-java/sun-javamail
	dev-java/xsdlib
	>=dev-java/xerces-2.8"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

EANT_BUILD_TARGET="image"
EANT_DOC_TARGET="javadocs"
EANT_EXTRA_ARGS="-Djava.mail=lib/mail.jar"

S="${WORKDIR}/jaxrpc-ri"

src_unpack() {

	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-length.patch"

	cd "${S}/lib"

	java-pkg_jar-from --build-only ant-core
	java-pkg_jar-from fastinfoset fastinfoset.jar FastInfoset.jar
	java-pkg_jar-from jaxp
	java-pkg_jar-from jsr67 jsr67.jar saaj-api.jar
	java-pkg_jar-from jsr101
	java-pkg_jar-from jsr173 jsr173.jar jsr173_api.jar
	java-pkg_jar-from relaxng-datatype
	java-pkg_jar-from saaj saaj.jar saaj-impl.jar
	java-pkg_jar-from sax
	java-pkg_jar-from servletapi-2.4 servlet-api.jar servlet.jar
	java-pkg_jar-from sun-jaf
	java-pkg_jar-from sun-javamail
	java-pkg_jar-from xsdlib
	java-pkg_jar-from xerces-2

	cd "${S}/src"
	find . -name '*.java' -exec sed -i \
		-e 's,com.sun.org.apache.xerces.internal,org.apache.xerces,g' \
		{} \;

}

src_install() {

	java-pkg_dojar "build/lib/jaxrpc-spi.jar"
	java-pkg_dojar "build/lib/jaxrpc-impl.jar"

	use doc && java-pkg_dojavadoc build/javadocs
	use source && java-pkg_dosrc src

}
