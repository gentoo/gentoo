# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/pdf-renderer/pdf-renderer-0.9.1.ebuild,v 1.5 2014/04/13 16:17:33 ago Exp $

EAPI=4

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="a 100% Java PDF renderer and viewer"
HOMEPAGE="https://pdf-renderer.dev.java.net/"
SRC_URI="http://java.net/projects/${PN}/downloads/download/PDFRenderer-full-${PV}.zip"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.5"
DEPEND="
	>=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}"

java_prepare() {
	find -name '*.jar' -exec rm -v {} + || die
}

# There is a test target (default from Netbeans)
# but no junit code

src_install() {
	java-pkg_dojar dist/*.jar

	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/com
}
