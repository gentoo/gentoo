# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2 java-ant-2

DESCRIPTION="Small footprint Dependency Injection container"
HOMEPAGE="http://www.picocontainer.org"
SRC_URI="http://dist.codehaus.org/${PN}/distributions/${P}-src.tar.gz"

LICENSE="BSD"
SLOT="1"
KEYWORDS="amd64 x86"
IUSE="doc source"

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-core-1.5
	source? ( app-arch/zip )
	"
#	test? (
#	    >=dev-java/junit-3.8.1
#	)"

RESTRICT="test"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Don't run tests automatically
	sed -i -e 's/compile,test/compile/' build.xml || die

# doesn't pass internal test even when trying vanilla build.xml that fetches own libs
#	if use test ; then
#    	    mkdir -p target/lib
#	    cd target/lib
#	    java-pkg_jar-from junit junit-3.8.1.jar
#	fi
}

src_compile() {
	local antflags="-Dfinal.name=${PN} -Dnoget=true jar"
	eant ${antflags} $(use_doc)
}

#src_test() {
#	local antflags="-Dfinal.name=${PN} -Dnoget=true test"
#	eant ${antflags}
#}

src_install() {
	java-pkg_dojar target/${PN}.jar

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/org
}
