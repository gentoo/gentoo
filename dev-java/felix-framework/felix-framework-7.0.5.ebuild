# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/felix/org.apache.felix.framework-7.0.5-source-release.tar.gz --slot 0 --keywords "~amd64" --ebuild felix-framework-7.0.5.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.felix:org.apache.felix.framework:7.0.5"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Implementation of the OSGi R8 core framework specification"
HOMEPAGE="https://felix.apache.org/documentation/subprojects/apache-felix-framework.html"
SRC_URI="mirror://apache/felix/org.apache.${PN//-/.}-${PV}-source-release.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ppc64"

# Common dependencies
# POM: pom.xml
# org.codehaus.mojo:animal-sniffer-annotations:1.9 -> >=dev-java/animal-sniffer-annotations-1.15:0

CP_DEPEND="dev-java/animal-sniffer-annotations:0"

# Compile dependencies
# POM: pom.xml
# org.apache.felix:org.apache.felix.resolver:2.0.4 -> >=dev-java/felix-resolver-2.0.4:0
# org.osgi:org.osgi.annotation:6.0.0 -> !!!artifactId-not-found!!!
# POM: pom.xml
# test? junit:junit:4.12 -> >=dev-java/junit-4.13.2:4
# test? org.easymock:easymock:2.5.2 -> >=dev-java/easymock-2.5.2:2.5
# test? org.mockito:mockito-all:1.10.19 -> !!!artifactId-not-found!!!
# test? org.ow2.asm:asm-all:5.2 -> !!!artifactId-not-found!!!

DEPEND="
	>=virtual/jdk-11:*
	${CP_DEPEND}
	dev-java/osgi-annotation:0
	dev-java/felix-resolver:0
	test? (
		dev-java/asm:4
		dev-java/easymock:2.5
		dev-java/mockito:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

S="${WORKDIR}/org.apache.felix.framework-${PV}"

JAVA_CLASSPATH_EXTRA="felix-resolver,osgi-annotation"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="asm-4,junit-4,easymock-2.5,mockito"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default
	# 58,91 pom.xml
	cat > src/main/java/module-info.java <<-EOF
		$( sed -n '/<moduleInfoSource>/,/<\/moduleInfoSource/p' pom.xml \
			| grep -v moduleInfoSource )
	EOF

	sed -e 's/{dollar}//g' -i src/main/resources/default.properties || die

	sed -e "s:\${pom.version}:${PV}:" \
		-i src/main/resources/org/apache/felix/framework/Felix.properties || die

	# bundling some classes from felix-resolver according to 99,132 pom.xml
	# if we don't bundle compilation would fail with:
	# src/main/java/module-info.java:23: error: package is empty or does not exist: org.osgi.service.resolver
	cd src/main/resources || die
	jar xvf "$(java-pkg_getjar --build-only felix-resolver felix-resolver.jar)" \
		org/{apache/felix,osgi/service}/resolver/ || die
}

src_compile() {
	java-pkg-simple_src_compile

	# according to pom.xml, line 129
	# grep the line between <Add-opens> and </Add-opens> from pom.xml
	local add_opens="$(sed -n '/<Add-opens>/,/<\/Add-opens/p' pom.xml \
		| grep -v Add-opens | tr -s '[:space:]')" || die
	echo "Add-opens:${add_opens}" > "${T}/Add-opens-to-MANIFEST.MF" \
		|| die "Add-opens-to-MANIFEST.MF failed"
	jar ufmv ${JAVA_JAR_FILENAME} "${T}/Add-opens-to-MANIFEST.MF" \
		|| die "updating MANIFEST.MF failed"
}

src_test() {
	# java.base does not "opens java.lang" to unnamed module
	# adding it to MANIFEST.MF would not fix the test failures.
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
	fi
	java-pkg-simple_src_test
}
