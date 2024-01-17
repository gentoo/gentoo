# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="xalan:serializer:2.7.3"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Transforming XML documents into HTML, text, or other XML document types"
HOMEPAGE="https://xalan.apache.org/"
SRC_URI="mirror://apache/xalan/xalan-j/source/xalan-j_${PV//./_}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/xalan/xalan-j/source/xalan-j_${PV//./_}-src.tar.gz.asc )"

S="${WORKDIR}/xalan-j_${PV//./_}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-xalan-j )"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/xalan-j.apache.org.asc"

JAVA_MAIN_CLASS="org.apache.xml.serializer.Version"
JAVA_RESOURCE_DIRS="resources"
JAVA_SRC_DIR="src"

src_prepare() {
	java-pkg-2_src_prepare
	# kill all non-serializer sources to ease javadocs and dosrc
	find src/org/ -type f ! -path "src/org/apache/xml/serializer/*" -delete || die

	# java-pkg-simple.eclass wants resources in JAVA_RESOURCE_DIRS
	mkdir -p resources || die
	pushd src > /dev/null || die
	find org -type f \
		! -name '*.java' \
		! -name 'Version.src' \
		! -name 'package.html' \
		| xargs cp --parent -t ../resources || die
	popd > /dev/null || die
}
