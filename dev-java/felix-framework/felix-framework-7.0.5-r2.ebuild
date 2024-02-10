# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.felix:org.apache.felix.framework:7.0.5"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Implementation of the OSGi R8 core framework specification"
HOMEPAGE="https://felix.apache.org/documentation/subprojects/apache-felix-framework.html"
SRC_URI="mirror://apache/felix/org.apache.${PN//-/.}-${PV}-source-release.tar.gz
	verify-sig? ( https://downloads.apache.org/felix/org.apache.${PN//-/.}-${PV}-source-release.tar.gz.asc )"
S="${WORKDIR}/org.apache.felix.framework-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CP_DEPEND="dev-java/animal-sniffer-annotations:0"

DEPEND="${CP_DEPEND}
	dev-java/felix-resolver:0
	dev-java/osgi-annotation:0
	>=virtual/jdk-11:*
	test? (
		dev-java/asm:9
		dev-java/easymock:2.5
		dev-java/mockito:0
	)"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-felix )"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/felix.apache.org.asc"

JAVA_CLASSPATH_EXTRA="felix-resolver,osgi-annotation"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="asm-9,junit-4,easymock-2.5,mockito"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
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
