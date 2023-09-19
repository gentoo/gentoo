# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="xerces:xercesImpl:2.12.2"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Xerces Java XML parser"
HOMEPAGE="https://xerces.apache.org/xerces2-j/index.html"
SRC_URI="mirror://apache/xerces/j/source/Xerces-J-src.${PV}.tar.gz
	verify-sig? ( https://downloads.apache.org/xerces/j/source/Xerces-J-src.${PV}.tar.gz.asc )"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="
	dev-java/xml-commons-external:1.4
	dev-java/xml-commons-resolver:0"

# JDK 11+ already privides the following file and the compilation
# fails if xerces provides it too. On contrary, compilation on 1.8
# fails if we don't provide the file because it's not part of 1.8.
# By restricting compilation to 1.8 and providing the file we build
# a jar that should work both on 1.8 and also on the newer versions
# of JDK.
# the file: "org/w3c/dom/html/HTMLDOMImplementation.class"
DEPEND="
	${CP_DEPEND}
	virtual/jdk:1.8"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-xerces-j )"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/xerces-j.apache.org.asc"

DOCS=( LICENSE NOTICE README {LICENSE.resolver,LICENSE.serializer,NOTICE.resolver,NOTICE.serializer}.txt )
HTML_DOCS=( {LICENSE.DOM-documentation,LICENSE.DOM-software,LICENSE-SAX,Readme}.html )

S="${WORKDIR}/${P//./_}"

JAVA_SRC_DIR="src"
JAVA_RESOURCE_DIRS="resources"

src_prepare() {
	java-pkg-2_src_prepare
	# java-pkg-simple.eclass wants resources in JAVA_RESOURCE_DIRS
	mkdir -p "resources/META-INF/services"|| die
	pushd "src" > /dev/null || die
		find -type f \
			\( -name 'javax.xml.*Factory' \
			-or -name '*DOMImplementationSourceList' \
			-or -name 'org.xml.sax.driver' \) \
			| xargs mv -t ../resources/META-INF/services || die
		find -type f \
			! -name '*.java' \
			! -name 'manifest.xerces' \
			! -name 'package.html' \
			! -name '*Configuration' \
			! -name '*DOMImplementationSourceImpl' \
			| xargs cp --parent -t ../resources || die
	popd > /dev/null || die
}
