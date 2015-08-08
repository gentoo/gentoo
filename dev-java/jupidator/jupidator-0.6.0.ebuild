# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-nodeps"

inherit java-pkg-2 java-ant-2 eutils

MY_P="${PN}.${PV}"

DESCRIPTION="Jupidator is a library/tool in Java for automatic updating of applications"
HOMEPAGE="http://www.sourceforge.net/projects/jupidator"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5
	dev-java/ant-core"
DEPEND=">=virtual/jdk-1.5
	dev-java/ant-core
	doc? ( app-text/xmlto )
	sys-devel/gettext"

S="${WORKDIR}/${PN}"

java_prepare() {
	rm -v dist/*.jar || die
	rm -rv src/java/org/apache/tools/bzip2 || die
	#Bundled ant classes
	java-ant_rewrite-classpath nbproject/build-impl.xml
	chmod +x i18n/make.sh || die
}

src_compile() {
	ANT_TASKS="ant-nodeps" eant -Dgentoo.classpath="$(java-pkg_getjars ant-core)" compile jar
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	use doc && java-pkg_dohtml -r dist/doc
	use source && java-pkg_dosrc src/java/com
}
