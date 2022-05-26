# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/OpenNMS/jrobin/archive/jrobin-1.6.0-1.tar.gz --slot 0 --keywords "~amd64 ~x86" --ebuild jrobin-1.6.0-r2.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jrobin:jrobin:1.6.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JRobin is a 100% pure Java alternative to RRDTool"
HOMEPAGE="https://github.com/OpenNMS/jrobin"
SRC_URI="https://github.com/OpenNMS/${PN}/archive/${P}-1.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

# Common dependencies
# POM: pom.xml
# junit:junit:4.11 -> >=dev-java/junit-4.13.2:4

# Compile dependencies
# POM: pom.xml
# test? org.easymock:easymock:3.1 -> >=dev-java/easymock-3.3.1:3.2

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/easymock:3.2
	)
"

RDEPEND="
	>=virtual/jre-1.8:*"

DOCS=( LICENSE.txt README.osgi )

S="${WORKDIR}/${PN}-${P}-1"

JAVA_SRC_DIR="src/main/java"
JAVA_MAIN_CLASS="org.jrobin.cmd.RrdCommander"
JAVA_RESOURCE_DIRS="src/main/resources"

# Workaround for https://github.com/OpenNMS/jrobin/issues/7
JAVADOC_ARGS="-source 8"

JAVA_TEST_GENTOO_CLASSPATH="easymock-3.2,junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default
	java-pkg_clean
}

src_test() {
	export LANG="C" LC_ALL="C"

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if [[ "${vm_version}" -ge "17" ]] ; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
	fi

	java-pkg-simple_src_test
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
