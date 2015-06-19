# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/annogen/annogen-0.1.0.ebuild,v 1.3 2014/08/10 20:06:45 slyfox Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source examples"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A tool which helps you work with JSR175 annotations"
HOMEPAGE="http://annogen.codehaus.org/"
SRC_URI="http://dist.codehaus.org/${PN}/distributions/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

CDEPEND="java-virtuals/stax-api:0
	dev-java/ant-core:0
	java-virtuals/jdk-with-com-sun:0
	>=dev-java/qdox-1.6:1.6"

RDEPEND=">=virtual/jdk-1.5
		${CDEPEND}"

DEPEND=">=virtual/jdk-1.5
		app-arch/unzip
		${CDEPEND}"

S="${WORKDIR}"

src_unpack() {
	default

	unzip -o -q "${S}/${PN}-src-${PV}.zip" || die
}

java_prepare() {
	find -name '*.jar' -exec rm -v {} + || die

	mkdir "${S}"/classes || die
}

src_compile() {
	find org -name "*.java" > "${T}/src.list" || die

	ejavac -d "${S}"/classes \
		-classpath $(java-pkg_getjars stax-api,qdox-1.6,ant-core):$(java-config --tools) \
		"@${T}/src.list"

	cd "${S}"/classes || die
	jar -cf "${S}/${PN}.jar" * || die "failed to create jar"
}

src_install() {
	java-pkg_dojar ${PN}.jar

	# For if this is ever needed:
	# java-pkg_register-ant-task

	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc org
	use examples && java-pkg_doexamples "examples"
}
