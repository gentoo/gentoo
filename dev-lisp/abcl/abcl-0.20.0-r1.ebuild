# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc"

MY_P="${PN}-src-${PV}"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Common Lisp implementation for the JVM"
HOMEPAGE="http://common-lisp.net/project/armedbear/"
SRC_URI="http://common-lisp.net/project/armedbear/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${MY_P}"

JAVADOC_FILES="java-${PN}"
JAVADOC_DIR="javadoc-${PN}"

src_compile() {
	eant abcl.compile
	eant abcl.jar
	if use doc; then
		find "${S}/src" -type f -name \*.java > "${JAVADOC_FILES}" || die
		mkdir -p "${JAVADOC_DIR}" || die
		ejavadoc \
			-d "${JAVADOC_DIR}" \
			-docencoding UTF-8 \
			-charset UTF-8 \
			-quiet \
			$(<"${JAVADOC_FILES}") || die
	fi
}

src_install() {
	java-pkg_dojar dist/abcl.jar
	java-pkg_dolauncher ${PN} --java_args "-server -Xrs" --main org.armedbear.lisp.Main
	use doc && java-pkg_dojavadoc "${JAVADOC_DIR}"
	einstalldocs
}
