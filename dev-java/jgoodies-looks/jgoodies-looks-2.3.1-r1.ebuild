# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jgoodies-looks/jgoodies-looks-2.3.1-r1.ebuild,v 1.1 2014/09/07 16:22:14 ercpe Exp $

EAPI=5

JAVA_PKG_IUSE="doc source examples"

inherit eutils java-pkg-2 java-ant-2

MY_PN="looks"
MY_PV="${PV//./_}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="JGoodies Looks Library"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/${MY_PN}/${MY_P}.zip"

LICENSE="BSD"
SLOT="2.0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_PN}-${PV}"

# bug #150970
EANT_FILTER_COMPILER="jikes"
# jar target fails unless we make descriptors.dir an existing directory
# update: it's where it looks for all.txt file
EANT_EXTRA_ARGS="-Ddescriptors.dir=\"${S}\""

EANT_BUILD_TARGET="jar-all"

java_prepare() {
	# remove the bootclasspath brokedness, make building demo optional
	epatch "${FILESDIR}/${PN}-2.0.4-build.xml.patch"

	# unzip the look&feel settings from bundled jar before we delete it
	unzip -j looks-${PV}.jar META-INF/services/javax.swing.LookAndFeel \
		|| die "unzip of javax.swing.LookAndFeel failed"
	# and rename it to what build.xml expects
	mv javax.swing.LookAndFeel all.txt

	find -name "*.jar" -delete || die
}

src_install() {
	java-pkg_dojar build/looks.jar

	dodoc RELEASE-NOTES.txt || die
	dohtml README.html || die
	use doc && java-pkg_dojavadoc build/docs/api
	use source && java-pkg_dosrc src/core/com
	use examples && java-pkg_doexamples src/demo
}
