# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A Web Publishing Framework for Apache"
HOMEPAGE="http://cocoon.apache.org/"
SRC_URI="mirror://apache/cocoon/${P}-src.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

# I know this way of building cocoon is not the best, it will be fixed for
# cocoon-2.2

src_unpack() {
	unpack ${A}

	cd "${S}"
	echo "# Gentoo build properties" > local.build.properties
	if ! use doc; then
		echo "exclude.javadocs=true" >> local.build.properties
		echo "exclude.webapp.javadocs=true" >> local.build.properties
		echo "exclude.webapp.documentation=true" >> local.build.properties
		echo "exclude.idldocs=true" >> local.build.properties
		echo "exclude.webapp.idldocs=true" >> local.build.properties
	fi
	java-ant_bsfix_files tools/targets/*-build.xml
	sed -i -e 's/maxmemory="192m"/maxmemory="384m"/' tools/src/blocks-build.xsl
}

src_compile() {
	sh build.sh war standalone-demo javadocs || die
}

src_install() {
	java-pkg_dowar build/${PN}/${PN}.war
	java-pkg_dojar build/${PN}/cocoon.jar
	java-pkg_jarinto /usr/share/${PN}/lib/core/
	java-pkg_dojar lib/core/*.jar
	insinto /usr/share/${PN}/lib
	doins "${S}/build/${PN}"/cocoon-*.jar "${S}/lib/jars.xml"
	for i in endorsed optional local; do
		dodir /usr/share/${PN}/lib/${i}
		insinto /usr/share/${PN}/lib/${i}
		doins "${S}/lib/${i}"/*
	done

	dodoc CREDITS.txt INSTALL.txt KEYS README.txt || die

	use doc && java-pkg_dojavadoc build/cocoon/javadocs

	docinto legal
	dodoc legal/*
}

pkg_postinst() {
	elog "This ebuild does no longer install the Cocoon webapp into"
	elog "any servlet container anymore. Copy /usr/share/${PN}/webapps/${PN}.war"
	elog "to your servlet container's webapps directory and restart the"
	elog "server."
}
