# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom biz.aQute.bndlib-5.3.0.pom.xml --download-uri https://github.com/bndtools/bnd/archive/refs/tags/5.3.0.REL.tar.gz --slot 0 --keywords "~amd64 ~x86" --ebuild bndlib-5.3.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="biz.aQute.bnd:biz.aQute.bndlib:5.3.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="bndlib: A Swiss Army Knife for OSGi"
HOMEPAGE="https://bnd.bndtools.org/"
SRC_URI="https://github.com/bndtools/bnd/archive/refs/tags/${PV}.REL.tar.gz -> ${P}.tar.gz
	https://repo1.maven.org/maven2/org/osgi/org.osgi.service.log/1.3.0/org.osgi.service.log-1.3.0-sources.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Common dependencies
# POM: biz.aQute.${P}.pom.xml
# org.slf4j:slf4j-api:1.7.25 -> >=dev-java/slf4j-api-1.7.30:0

CDEPEND="
	dev-java/slf4j-api:0
"

# Compile dependencies
# POM: biz.aQute.${P}.pom.xml
# org.osgi:org.osgi.namespace.contract:1.0.0 -> >=dev-java/osgi-namespace-contract-1.0.0:0
# org.osgi:org.osgi.namespace.extender:1.0.1 -> >=dev-java/osgi-namespace-extender-1.0.1:0
# org.osgi:org.osgi.namespace.implementation:1.0.0 -> >=dev-java/osgi-namespace-implementation-1.0.0:0
# org.osgi:org.osgi.namespace.service:1.0.0 -> >=dev-java/osgi-namespace-service-1.0.0:0
# org.osgi:org.osgi.service.log:1.3.0 -> >=dev-java/osgi-service-log-1.5.0:0
# org.osgi:org.osgi.service.repository:1.1.0 -> >=dev-java/osgi-service-repository-1.1.0:0
# org.osgi:org.osgi.util.function:1.1.0 -> >=dev-java/osgi-util-function-1.1.0:0
# org.osgi:org.osgi.util.promise:1.1.1 -> >=dev-java/osgi-util-promise-1.1.1:0
# org.osgi:osgi.annotation:8.0.0 -> >=dev-java/osgi-annotation-8.0.0:0
# org.osgi:osgi.core:6.0.0 -> >=dev-java/osgi-core-8.0.0:0

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	dev-java/osgi-annotation:0
	dev-java/osgi-annotation-versioning:0
	dev-java/osgi-core:0
	dev-java/osgi-namespace-contract:0
	dev-java/osgi-namespace-extender:0
	dev-java/osgi-namespace-implementation:0
	dev-java/osgi-namespace-service:0
	dev-java/osgi-service-repository:0
	dev-java/osgi-service-serviceloader:0
	dev-java/osgi-util-function:0
	dev-java/osgi-util-promise:0
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="slf4j-api"
JAVA_CLASSPATH_EXTRA="osgi-annotation,osgi-annotation-versioning,osgi-core,osgi-namespace-contract,osgi-namespace-extender,osgi-namespace-implementation,osgi-namespace-service,osgi-service-repository,osgi-service-serviceloader,osgi-util-function,osgi-util-promise"

JAVA_SRC_DIR="src"
JAVA_RESOURCE_DIRS="resources"

src_prepare() {
	default
	java-pkg_clean

	mkdir "${JAVA_SRC_DIR}" || die

	local annot="${S}"/bnd-"${PV}".REL/biz.aQute.bnd.annotation/src/aQute
	local bnd="${S}"/bnd-"${PV}".REL/biz.aQute.bndlib/src/aQute
	local libg="${S}"/bnd-"${PV}".REL/aQute.libg/src/aQute

	pushd "${libg}"/libg
	rm -r asn1 cafs classdump classloaders clauses fileiterator filters forker log remote sax shacache slf4j tarjan xslt || die
	popd || die

	pushd "${libg}"/lib
	rm -r annotations codec config consoleapp data dot env getopt index inject justif log2reporter markdown promise properties putjar xmldtoparser || die
	popd || die

	# Compilation would fail unless we add osgi-service-log to the sources. And it must be 1.3.0 since with the later versions it also fails.
	# src/bnd/junit/ConsoleLogger.java:33: error: LogEntryImpl is not abstract and does not override abstract method getLocation() in LogEntry
	# src/bnd/junit/ConsoleLogger.java:81: error: ConsoleLogger.Facade is not abstract and does not override abstract method <L>getLogger(Bundle,String,Class<L>) in LoggerFactory
	#	-C "${S}"/org osgi/service/log \

	pushd "${JAVA_SRC_DIR}"
	jar --create \
		-C "${S}"/org osgi/service/log \
		-C "${annot}" bnd \
		-C "${bnd}" bnd \
		-C "${bnd}" lib/deployer \
		-C "${bnd}" lib/spring \
		-C "${libg}" lib \
		-C "${libg}" libg \
		-C "${libg}" service \
		| jar --extract  || die
	popd || die "stuffing JAVA_SRC_DIR failed"

	mkdir --parents "${JAVA_RESOURCE_DIRS}/aQute" || die
	cp -r  "${JAVA_SRC_DIR}"/* "${JAVA_RESOURCE_DIRS}/aQute"  || die
	find "${JAVA_RESOURCE_DIRS}" -type f -name '*.java' -exec rm -rf {} + || die
}
