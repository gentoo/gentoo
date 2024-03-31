# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="biz.aQute.bnd:biz.aQute.bnd:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="bndlib: A Swiss Army Knife for OSGi"
HOMEPAGE="https://bnd.bndtools.org/"
SRC_URI="https://github.com/bndtools/bnd/archive/${PV}.tar.gz -> aQute.bnd-${PV}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0 EPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

BDEPEND="app-arch/zip"

CP_DEPEND="
	~dev-java/bndlib-${PV}:0
	dev-java/felix-resolver:0
	dev-java/guava:0
	dev-java/javaparser-core:0
	dev-java/jline:2
	dev-java/jtwig-core:0
	dev-java/osgi-annotation:0
	dev-java/osgi-cmpn:8
	dev-java/osgi-core:0
	dev-java/slf4j-simple:0
	dev-java/snakeyaml:0
	dev-java/xz-java:0
"

DEPEND="${CP_DEPEND}
	dev-java/commons-lang:3.6
	dev-java/eclipse-jdt-annotation:0
	dev-java/felix-gogo-runtime:0
	dev-java/slf4j-api:0
	dev-java/jtwig-reflection:0
	dev-java/osgi-service-log:0
	dev-java/osgi-service-subsystem:0
	>=virtual/jdk-17:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-17:*"

PATCHES=(
	"${FILESDIR}/bnd-7.0.0-aQute.bnd.main.bnd.patch"
)

JAVA_AUTOMATIC_MODULE_NAME="biz.aQute.bnd"
JAVA_CLASSPATH_EXTRA="
	commons-lang-3.6
	eclipse-jdt-annotation
	jtwig-reflection
	felix-gogo-runtime
	osgi-service-subsystem
	slf4j-api
"
JAVA_MAIN_CLASS="aQute.bnd.main.bnd"
JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR=(
	"biz.aQute.bnd.exporters/src"
	"biz.aQute.bnd.reporter/src"
	"biz.aQute.bnd/src"
	"biz.aQute.remote/src"
	"biz.aQute.repository/src"
	"biz.aQute.resolve/src"
)

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	mkdir res || die

	# java-pkg-simple wants resources in JAVA_RESOURCE_DIRS
	pushd biz.aQute.bnd/src > /dev/null || die
		find -type f \
			! -name '*.java' \
			| xargs cp --parent -t ../../res || die
	popd > /dev/null || die
}

src_compile() {
	# There is another version of osgi-service-log in osgi-core-0
	JAVA_GENTOO_CLASSPATH_EXTRA=":$(java-pkg_getjars --build-only osgi-service-log)"
	java-pkg-simple_src_compile

	# remove classes which are not in upstream's jar file
	zip -d ${PN}.jar \
		"*/remote/agent/*" \
		"*/remote/embedded/*" \
		"*/remote/main/*" \
		"*/remote/plugin/*" \
		"*/remote/test/*" \
		|| die
}
