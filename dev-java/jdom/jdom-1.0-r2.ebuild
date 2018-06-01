# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java API to manipulate XML data"
SRC_URI="http://www.jdom.org/dist/source/${P}.tar.gz"
HOMEPAGE="http://www.jdom.org"
LICENSE="JDOM"
SLOT="${PV}"
KEYWORDS="amd64 ppc64 x86"
COMMON_DEP="dev-java/saxpath
		>=dev-java/xerces-2.7"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	rm -v build/*.jar lib/*.jar || die
	rm -rf build/{apidocs,samples} || die

	cd "${S}/lib"
	java-pkg_jar-from saxpath,xerces-2

	if has_version '=dev-java/jaxen-1.1*'; then
		elog "jaxen detected - building jaxen support."
		elog "you can ignore the warnings below"
		elog "one day there will be better solution"
		JAVA_PKG_STRICT="" java-pkg_jar-from jaxen-1.1
	fi
}

src_compile() {
	# to prevent a newer jdom from going into cp
	# (EANT_ANT_TASKS doesn't work with none)
	ANT_TASKS="none" eant package $(use_doc)
}

src_install() {
	java-pkg_dojar build/*.jar

	dodoc CHANGES.txt COMMITTERS.txt README.txt TODO.txt || die
	use doc && java-pkg_dojavadoc build/apidocs
	use examples && java-pkg_doexamples samples
	use source && java-pkg_dosrc src/java/org
}

pkg_postinst() {
	if ! has_version '=dev-java/jaxen-1.1*'; then
		elog ""
		elog "If you want jaxen support for jdom then"
		elog "please emerge =dev-java/jaxen-1.1* first and"
		elog "re-emerge jdom.  Sorry for the"
		elog "inconvenience, this is to break out of the"
		elog "circular dependencies."
		elog ""
	fi
}
