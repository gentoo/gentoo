# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-ivy"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A collection of tasks for Apache Ant"
HOMEPAGE="http://ant-contrib.sourceforge.net/"
SRC_URI="mirror://sourceforge/ant-contrib/${PN}-${PV/_beta/b}-src.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~x86-macos"

#	test? ( dev-java/ant-junit dev-java/ant-testutil )
CP_DEPEND="
	>=dev-java/ant-core-1.7.0:0
	dev-java/ant-ivy:0
	>=dev-java/bcel-5.1:0
	dev-java/commons-httpclient:3
	dev-java/xerces:2
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.4"

# javatoolkit for cElementTree
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.4
	>=dev-java/javatoolkit-0.3.0-r2"

S="${WORKDIR}/${PN}"
PATCHES=( "${FILESDIR}"/tests-visibility.patch )

rewrite_build_xml() {
	python <<EOF
import xml.etree.cElementTree as et
tree = et.ElementTree(file='build.xml')
root = tree.getroot()
root.append(et.Element('path',id='test.classpath'))
root.append(et.Element('path',id='compile.classpath'))
skip=['resolve','classpath']
for target in tree.getiterator("target"):
	if target.attrib['name'] in skip:
		target.attrib['if'] = 'false'

tree.write('build.xml')
EOF
	[[ $? != 0 ]] && die "Removing taskdefs failed"
}

src_prepare() {
	default
	rewrite_build_xml
	java-pkg_clean
	java-pkg-2_src_prepare
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_EXTRA_ARGS="-Dversion=${PV} -Ddep.available=true"

# Can't load bcel for some reason
RESTRICT="test"
# for tests
EANT_GENTOO_CLASSPATH_EXTRA="target/${PN}.jar"

src_install() {
	java-pkg_dojar target/${PN}.jar

	java-pkg_register-ant-task

	use doc && java-pkg_dojavadoc target/docs/api
	use source && java-pkg_dosrc src/java/net

	java-pkg_dohtml -r docs/manual
}
