# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, #839681
JAVA_PKG_IUSE="doc source"
MAVEN_PROVIDES="com.${PN}:${PN}-core:${PV} com.${PN}:${PN}-ui:${PV}"

inherit desktop java-pkg-2 java-pkg-simple xdg

DESCRIPTION="Feature-filled Bittorrent client based on the Azureus open source project"
HOMEPAGE="https://www.biglybt.com"
SRC_URI="https://github.com/BiglySoftware/BiglyBT/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/BiglyBT-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

CP_DEPEND="
	dev-java/commons-cli:1
	dev-java/swt:4.27
"

# Due to removal of AENameServiceDescriptor it would fail to start under jdk:1.8
# StartServer ERROR: unable to bind to 127.0.0.1:6880 listening for passed torrent info: \
# sun.net.spi.nameservice.NameServiceDescriptor: Provider com.biglybt.core.util.spi.AENameServiceDescriptor not found
# Restricting to jdk:11 for https://bugs.gentoo.org/888859
DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=(
	CODING_GUIDELINES.md
	CONTRIBUTING.md
	ChangeLog.txt
	README.md
	TRANSLATE.md
)

JAVADOC_SRC_DIRS=( {core,uis}/src )

PATCHES=(
	"${FILESDIR}/biglybt-3.2.0.0-disable-SWTUpdateChecker.patch"
	"${FILESDIR}/biglybt-3.2.0.0-disable-shared-plugins.patch"
	"${FILESDIR}/biglybt-3.5.0.0-Entities.javadoc.patch"
	"${FILESDIR}/biglybt-3.6.0.0-disable-PluginUpdatePlugin.patch"
)

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	# AENameServiceDescriptor fails to compile with jdk >= 11
	# "error: package sun.net.spi.nameservice does not exist"
	# https://github.com/BiglySoftware/BiglyBT/pull/2611
	rm -r core/src/com/biglybt/core/util/spi || die
#	rm -r core/src/META-INF || die

	cp -r core/{src,resources} || die
	find core/resources -type f -name '*.java' -exec rm -rf {} + || die "deleting classes failed"

	cp -r uis/{src,resources} || die
	find uis/resources -type f -name '*.java' -exec rm -rf {} + || die "deleting classes failed"
}

src_compile() {
	einfo "Compiling module \"core\""
	JAVA_JAR_FILENAME="${PN}-core.jar"
	JAVA_RESOURCE_DIRS="core/resources"
	JAVA_SRC_DIR="core/src"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA="${PN}-core.jar"

	einfo "Compiling module \"uis\""
	JAVA_JAR_FILENAME="BiglyBT.jar"
	JAVA_LAUNCHER_FILENAME="${PN}"
	JAVA_MAIN_CLASS="com.${PN}.ui.Main"
	JAVA_RESOURCE_DIRS="uis/resources"
	JAVA_SRC_DIR="uis/src"
	java-pkg-simple_src_compile

	if use doc; then
		einfo "Creating javadoc"
		JAVADOC_CLASSPATH="${JAVA_GENTOO_CLASSPATH}"
		ejavadoc
	fi
}

src_install() {
	java-pkg-simple_src_install

	make_desktop_entry "${PN}" BiglyBT "${PN}" "Network;FileTransfer"

	if use source; then
		java-pkg_dosrc "core/src/*"
		java-pkg_dosrc "uis/src/*"
	fi
	default
}
