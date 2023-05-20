# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="biz.aQute.bnd:biz.aQute.bnd:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="bndlib: A Swiss Army Knife for OSGi"
HOMEPAGE="https://bnd.bndtools.org/"
# Some compile dependencies to get packaged:
SRC_URI="https://github.com/bndtools/bnd/archive/${PV}.tar.gz -> aQute.bnd-${PV}.tar.gz
	https://repo1.maven.org/maven2/com/github/javaparser/javaparser-core/3.13.10/javaparser-core-3.13.10.jar
	https://repo1.maven.org/maven2/org/jtwig/jtwig-core/5.86.1.RELEASE/jtwig-core-5.86.1.RELEASE.jar
	https://repo1.maven.org/maven2/org/jtwig/jtwig-reflection/5.86.1.RELEASE/jtwig-reflection-5.86.1.RELEASE.jar
	https://repo1.maven.org/maven2/org/apache/felix/org.apache.felix.gogo.runtime/1.1.0/org.apache.felix.gogo.runtime-1.1.0.jar
	https://repo1.maven.org/maven2/org/osgi/org.osgi.service.subsystem/1.1.0/org.osgi.service.subsystem-1.1.0.jar
	https://repo1.maven.org/maven2/org/eclipse/jdt/org.eclipse.jdt.annotation/2.2.600/org.eclipse.jdt.annotation-2.2.600.jar"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0 EPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/ant-core:0
	dev-java/commons-lang:3.6
	dev-java/felix-resolver:0
	dev-java/guava:0
	dev-java/jline:2
	dev-java/junit:4
	dev-java/osgi-annotation:0
	dev-java/osgi-cmpn:8
	dev-java/osgi-core:0
	dev-java/slf4j-api:0
	dev-java/slf4j-simple:0
	dev-java/snakeyaml:0
	dev-java/xz-java:0
"

DEPEND="${CP_DEPEND}
	dev-java/osgi-service-log:0
	>=virtual/jdk-1.8:*
"

RDEPEND="${CP_DEPEND}
	dev-java/osgi-service-log:0
	>=virtual/jre-1.8:*
"

BDEPEND="app-arch/zip"

PATCHES=(
	"${FILESDIR}/bnd-6.4.0-aQute-bnd-main-bnd.patch"
)

JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR=(
	"aQute.libg/src"
	"biz.aQute.bnd.annotation/src"
	"biz.aQute.bnd.ant/src"
	"biz.aQute.bnd.exceptions/src"
	"biz.aQute.bnd.exporters/src"
	"biz.aQute.bnd.reporter/src"
	"biz.aQute.bnd.util/src"
	"biz.aQute.bnd/src"
	"biz.aQute.bndlib/src"
	"biz.aQute.launchpad/src"
	"biz.aQute.remote/src"
	"biz.aQute.repository/src"
	"biz.aQute.resolve/src"
)

src_prepare() {
	java-pkg-2_src_prepare
	default
	mkdir res || die

	# java-pkg-simple wants resources in JAVA_RESOURCE_DIRS
	mv biz.aQute.bndlib/img	res || die
	pushd biz.aQute.bndlib/src > /dev/null || die
		find -type f \
			! -name '*.java' \
			| xargs cp --parent -t ../../res || die
	popd > /dev/null || die
	pushd biz.aQute.bnd/src > /dev/null || die
		find -type f \
			! -name '*.java' \
			| xargs cp --parent -t ../../res || die
	popd > /dev/null || die
}

src_compile() {
	# There is another version of osgi-service-log in osgi-core-0
	JAVA_GENTOO_CLASSPATH_EXTRA=":$(java-pkg_getjars osgi-service-log)"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/javaparser-core-3.13.10.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/jtwig-core-5.86.1.RELEASE.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/jtwig-reflection-5.86.1.RELEASE.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/org.apache.felix.gogo.runtime-1.1.0.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/org.osgi.service.subsystem-1.1.0.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/org.eclipse.jdt.annotation-2.2.600.jar"
	java-pkg-simple_src_compile

	# remove classes which are not in upstream's jar file
	zip -d ${PN}.jar \
		"*/lib/annotations/*" \
		"*/lib/codec/*" \
		"*/lib/config/*" \
		"*/lib/consoleapp/*" \
		"*/lib/data/*" \
		"*/lib/env/*" \
		"*/lib/exceptions/*" \
		"*/lib/index/*" \
		"*/lib/log2reporter/*" \
		"*/lib/properties/*" \
		"*/lib/putjar/*" \
		"*/lib/regex/*" \
		"*/lib/xmldtoparser/*" \
		"*/libg/asn1/*" \
		"*/libg/cafs/*" \
		"*/libg/classloaders/*" \
		"*/libg/clauses/*" \
		"*/libg/dtos/*" \
		"*/libg/fileiterator/*" \
		"*/libg/filters/*" \
		"*/libg/log/*" \
		"*/libg/remote/*" \
		"*/libg/sax/*" \
		"*/libg/shacache/*" \
		"*/libg/slf4j/*" \
		"*/libg/xslt/*" \
		"*/remote/agent/*" \
		"*/remote/embedded/*" \
		"*/remote/main/*" \
		"*/remote/plugin/*" \
		"*/remote/test/*" \
		|| die
}
