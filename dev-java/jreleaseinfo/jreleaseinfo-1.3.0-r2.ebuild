# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jreleaseinfo/jreleaseinfo-1.3.0-r2.ebuild,v 1.1 2014/01/02 15:13:14 tomwij Exp $

EAPI="5"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Ant Task for build-time creation of Java source file with version, build number or other info"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="source"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip:0
	dev-java/ant-core:0
	source? ( app-arch/zip:0 )"

RDEPEND=">=virtual/jre-1.4
	dev-java/ant-core:0"

EANT_GENTOO_CLASSPATH="ant-core"

java_prepare() {
	java-ant_rewrite-classpath build.xml
}

src_install() {
	java-pkg_newjar "target/${P}.jar"

	dodoc LICENSE.txt

	use source && java-pkg_dosrc src/java/ch
}
