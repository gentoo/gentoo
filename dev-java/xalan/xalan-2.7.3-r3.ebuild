# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="xalan:xalan:2.7.3"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Transforming XML documents into HTML, text, or other XML document types"
HOMEPAGE="https://xalan.apache.org/"
SRC_URI="mirror://apache/xalan/xalan-j/source/xalan-j_${PV//./_}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/xalan/xalan-j/source/xalan-j_${PV//./_}-src.tar.gz.asc )
	x86? ( https://www2.cs.tum.edu/projects/cup/releases/java-cup-bin-11b-20160615.tar.gz )"

S="${WORKDIR}/xalan-j_${PV//./_}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

# https://bugs.gentoo.org/936274 - for x86 we provide the precompiled java-cup
COMMON_DEPEND="
	!x86? ( dev-java/javacup:0 )
"

CP_DEPEND="
	dev-java/bcel:0
	~dev-java/xalan-serializer-${PV}:${SLOT}
	dev-java/xerces:2
"

# restrict to max Java 25
# https://bugs.openjdk.org/browse/JDK-8359053
DEPEND="
	${COMMON_DEPEND}
	${CP_DEPEND}
	<=virtual/jdk-25:*
"

RDEPEND="
	${COMMON_DEPEND}
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-xalan-j )"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/xalan-j.apache.org.asc"

JAVA_MAIN_CLASS="org.apache.xalan.xslt.Process"
JAVA_SRC_DIR="src"

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached \
			"${DISTDIR}/xalan-j_${PV//./_}-src.tar.gz" \
			"${DISTDIR}/xalan-j_${PV//./_}-src.tar.gz.asc"
	fi
	unpack "xalan-j_${PV//./_}-src.tar.gz"
	use x86 && unpack java-cup-bin-11b-20160615.tar.gz
}

src_prepare() {
	java-pkg-2_src_prepare
	# serializer is packaged separately
	rm -r src/org/apache/xml/serializer || die "cannot remove serializer"
	use !x86 && JAVA_GENTOO_CLASSPATH="javacup"
	use x86 && JAVA_GENTOO_CLASSPATH_EXTRA="${WORKDIR}/java-cup-11b-runtime.jar:${WORKDIR}/java-cup-11b.jar"
}

src_install() {
	java-pkg-simple_src_install
	if use x86; then
		java-pkg_newjar "${WORKDIR}/java-cup-11b-runtime.jar" java-cup-runtime.jar
		java-pkg_newjar "${WORKDIR}/java-cup-11b.jar" java-cup.jar
		java-pkg_regjar "${ED}/usr/share/${PN}/lib/java-cup-runtime.jar"
		java-pkg_regjar "${ED}/usr/share/${PN}/lib/java-cup.jar"
	fi
}
