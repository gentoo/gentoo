# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JNDI Kit is a toolkit designed to help with the construction of JNDI providers"
HOMEPAGE="http://spice.codehaus.org/"
SRC_URI="http://dist.codehaus.org/spice/distributions/${P}-src.tar.gz"
LICENSE="Spice-1.1"
SLOT="0"
KEYWORDS="~x86"

RDEPEND=">=virtual/jre-1.4"
DEPEND="
	>=virtual/jdk-1.4
	test? ( dev-java/ant-junit )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	java-ant_ignore-system-classes
	java-ant_rewrite-classpath
}

src_compile() {
	java-pkg-2_src_compile
	cd target/classes
	rmic org.codehaus.spice.jndikit.rmi.server.RMINamingProviderImpl \
		|| die "rmic failed"
}

src_test() {
	einfo "Tests need a network connection so they will fail without it"
	ANT_TASKS="ant-junit" eant test -DJunit.present=true \
		-Dgentoo.classpath="$(java-pkg_getjars --build-only junit)"
}

src_install() {
	java-pkg_newjar target/${P}.jar
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
