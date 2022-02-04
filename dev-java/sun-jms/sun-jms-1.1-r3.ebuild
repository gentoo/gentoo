# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

DOWNLOAD_PAGE="http://download.oracle.com/otndocs/jcp/7542-jms-1.1-fr-doc-oth-JSpec/"
At="jms-${PV/./_}-fr-apidocs.zip"

DESCRIPTION="The Java Message Service (JMS) API"
HOMEPAGE="https://www.oracle.com/java/technologies/java-message-service.html"
SRC_URI="${At}"

LICENSE="sun-bcla-jms"
SLOT=0
KEYWORDS="amd64 arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="doc"

DEPEND=" >=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

RESTRICT="bindist fetch"

S="${WORKDIR}/${PN//sun-/}${PV}"

pkg_nofetch() {
	einfo
	einfo " Due to license restrictions, we cannot fetch the"
	einfo " distributables automagically."
	einfo
	einfo " 1. Visit ${DOWNLOAD_PAGE}"
	einfo " 2. Accept the License Agreement"
	einfo " 3. Download ${At}"
	einfo " 4. Move the file to your DISTDIR directory"
	einfo
}

src_prepare() {
	default
	rm -v lib/*.jar || die
}

src_compile() {
	mkdir build || die
	cd src/share || die
	ejavac -nowarn -d "${S}"/build $(find . -name "*.java") || die
	if use doc ; then
		mkdir "${S}"/api || die
		javadoc -d "${S}"/api -quiet javax.jms || die
	fi

	cd "${S}" || die
	jar cf jms.jar -C build . || die
}

src_install() {
	java-pkg_dojar jms.jar
	use doc && java-pkg_dohtml -r api
}
