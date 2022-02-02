# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="xerces:xercesImpl:2.12.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Xerces Java XML parser"
HOMEPAGE="https://xerces.apache.org/xerces2-j/index.html"
SRC_URI="mirror://apache/xerces/j/source/Xerces-J-src.2.12.2.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="
	dev-java/xml-commons-external:1.4
	dev-java/xml-commons-resolver:0"

# For higher jdk versions we would beed to remove
# the "org/w3c/dom/html/HTMLDOMImplementation.class"
# But then it would fail running under jre:1.8
DEPEND="
	${CP_DEPEND}
	virtual/jdk:1.8"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( LICENSE NOTICE README {LICENSE.resolver,LICENSE.serializer,NOTICE.resolver,NOTICE.serializer}.txt )
HTML_DOCS=( {LICENSE.DOM-documentation,LICENSE.DOM-software,LICENSE-SAX,Readme}.html )

S="${WORKDIR}/${P//./_}"

JAVA_SRC_DIR="src"
JAVA_RESOURCE_DIRS="resources"

src_prepare() {
	default
	mkdir "${JAVA_RESOURCE_DIRS}" || die
	cp -r "${JAVA_SRC_DIR}/org" "${JAVA_RESOURCE_DIRS}" || die
	find "${JAVA_RESOURCE_DIRS}" -type f -name '*.java' -exec rm -rf {} + || die
	rm "${JAVA_RESOURCE_DIRS}"/org/apache/xerces/{dom/org.apache.xerces.dom.DOMImplementationSourceImpl,xs/datatypes/package.html,parsers/org*} || die

#	local vm_version="$(java-config -g PROVIDES_VERSION)"
#	if [[ "${vm_version}" != "1.8" ]] ; then
#		rm -rv "src/org/w3c" || die
#	fi
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
