# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java date chooser bean for graphically picking a date"
HOMEPAGE="https://toedter.com/jcalendar/"
SRC_URI="https://www.toedter.com/download/${P}.zip"

LICENSE="LGPL-2.1"
SLOT="1.2"
KEYWORDS="amd64 x86"

BDEPEND="app-arch/unzip"

CP_DEPEND="dev-java/jgoodies-looks:2.6"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_MAIN_CLASS="com.toedter.calendar.demo.JCalendarDemo"
JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR="src"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean
	mkdir -p res/META-INF || die
	mv src/jcalendar.manifest res/META-INF/MANIFEST.MF || die
	pushd src > /dev/null || die
		find com -type f ! -name '*.java' \
			| xargs cp --parents -t ../res || die
	popd > /dev/null || die
}
