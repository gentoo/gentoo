# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.felix:org.apache.felix.main:7.0.5"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Open source OSGi framework by Apache Software Foundation"
HOMEPAGE="https://felix.apache.org/documentation/index.html"
SRC_URI="mirror://apache/felix/org.apache.${PN//-/.}-${PV}-source-release.tar.gz
	verify-sig? ( https://downloads.apache.org/felix/org.apache.${PN//-/.}-${PV}-source-release.tar.gz.asc )"
S="${WORKDIR}/org.apache.felix.main-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# org.apache.felix:org.apache.felix.framework:7.0.5 -> >=dev-java/felix-framework-7.0.5:0

CP_DEPEND="~dev-java/felix-framework-${PV}:0"

DEPEND="
	>=virtual/jdk-11:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-felix )"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/felix.apache.org.asc"

DOCS=( DEPENDENCIES NOTICE )

JAVA_MAIN_CLASS="org.apache.felix.main.Main"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	default
	# 58,91 pom.xml
	cat > src/main/java/module-info.java <<-EOF || die
		$( sed -n '/<moduleInfoSource>/,/<\/moduleInfoSource/p' pom.xml \
			| grep -v moduleInfoSource )
	EOF

	# according to pom.xml, line 91
	local add_opens="$( sed -n '/<Add-opens>/,/<\/Add-opens/p' pom.xml \
		| grep -v Add-opens | tr -s '[:space:]')" || die
	mkdir src/main/resources/META-INF || die
	echo  "Add-opens:${add_opens}" >> src/main/resources/META-INF/MANIFEST.MF \
		|| die "creating MANIFEST.MF failed"

	# no idea what to do with felix.log.level=${log.level} here, but ...
	sed -e 's/{dollar}//' -i src/main/resources/config.properties || die

	# bundling some classes from felix-framework according to 78,94 pom.xml
	# if we don't bundle compilation of module-info would fail
	cd src/main/resources || die
	jar xvf "$(java-pkg_getjar --build-only felix-framework felix-framework.jar)" \
		default.properties org/ || die "felix-framework.jar does not exist"
}

src_install() {
	dodoc -r doc
	java-pkg-simple_src_install
}
