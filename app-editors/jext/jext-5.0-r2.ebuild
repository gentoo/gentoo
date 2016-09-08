# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc"
inherit java-pkg-2 java-ant-2

DESCRIPTION="A text editor written in Java"
HOMEPAGE="https://sourceforge.net/projects/jext/"
MY_PV="${PV/_}"
SRC_URI="mirror://sourceforge/${PN}/${PN}-sources-${MY_PV}.tar.gz"
LICENSE="|| ( GPL-2 JPython )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="dev-java/jython:2.7
	dev-java/jgoodies-looks:1.2
	dev-java/gnu-regexp:1"
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

S="${WORKDIR}/${PN}-src-${MY_PV}"

# Necessary otherwise it chokes on compiling with jdk-1.8
# due to unmappable characters.
JAVA_ANT_ENCODING="ISO-8859-1"

java_prepare() {
	# bundles some com.microstar.xml who knows what's that
	# also com.jgoodies.uif_lite which is apparently some jgoodies-looks
	# example code which we don't package and there is probably no point
	rm -v "${S}"/extplugins/Admin/*.jar || die
	rm -rf src/lib/gnu || die

	# Fix "enum as a keyword" error.
	epatch "${FILESDIR}"/"${P}"-enum-as-keyword.patch
}

src_compile() {
	cd "${S}/src" || die
	eant jar $(use_doc javadocs) \
		-Dclasspath="$(java-pkg_getjars jython-2.7,jgoodies-looks-1.2,gnu-regexp-1)"
}

src_install () {
	java-pkg_newjar lib/${P}.jar
	java-pkg_dojar lib/dawn*.jar

	java-pkg_dolauncher ${PN} \
		--main org.jext.Jext \
		--java_args '-Dpython.path=$(java-config --classpath=jython-2.7)' \
		-pre "${FILESDIR}/${PN}-pre"

	if use doc; then
		java-pkg_dohtml -r docs/api
	fi
}

pkg_postinst() {
	elog "Plugins are currently not built/installed. Patches welcome."
}
