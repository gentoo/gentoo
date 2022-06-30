# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The java part of sys-devel/gettext"
HOMEPAGE="https://www.gnu.org/software/gettext/"
SRC_URI="mirror://gnu/gettext/gettext-${PV}.tar.xz"
#	SRC_URI+=" verify-sig? ( mirror://gnu/gettext/gettext-${PV}.tar.xz.sig )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND=""

RDEPEND=">=virtual/jre-1.8
	${CP_DEPEND}"
DEPEND=">=virtual/jdk-1.8
	${CP_DEPEND}"

src_prepare() {
	java-pkg_clean
	mkdir "${WORKDIR}/gettext-java" || die
	mv gettext-"${PV}"/gettext-runtime/intl-java gettext-java || die
	mv gettext-"${PV}"/gettext-tools/src gettext-java || die
	java-pkg-2_src_prepare
}

src_compile() {
	einfo "Compiling libintl.jar"
	JAVA_SRC_DIR="gettext-java/intl-java"
	JAVA_JAR_FILENAME="libintl.jar"
	echo "$(pwd)"
	rm "${WORKDIR}/${JAVA_SRC_DIR}"/Makefile* || die
	java-pkg-simple_src_compile
	rm -r target || die

	einfo "Compiling gettext.jar"
	JAVA_SRC_DIR="gettext-java/src"
	JAVA_JAR_FILENAME="gettext.jar"
	java-pkg-simple_src_compile
	rm -r target || die

	if use doc; then
		JAVA_SRC_DIR=(
			"gettext-java/intl-java"
			"gettext-java/src"
		)
		JAVA_JAR_FILENAME="ignoreme.jar"
		java-pkg-simple_src_compile
	fi
}

src_install() {
	einstalldocs # https://bugs.gentoo.org/789582

	java-pkg_dojar "libintl.jar"
	java-pkg_dojar "gettext.jar"

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	if use source; then
		java-pkg_dosrc "gettext-java/intl-java/*"
		java-pkg_dosrc "gettext-java/src/*"
	fi
}
