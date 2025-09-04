# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# for 3.8.0.2 USE=doc produces 2 errors:
#   uis/src/com/biglybt/ui/swt/plugin/net/buddy/swt/BuddyPluginView.java:68:
#   uis/src/com/biglybt/ui/swt/plugin/net/buddy/swt/BuddyPluginViewChat.java:45:
#   error: package com.biglybt.ui.swt.plugin.net.buddy does not exist
JAVA_PKG_IUSE="source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"
MAVEN_PROVIDES="com.${PN}:${PN}-core:${PV} com.${PN}:${PN}-ui:${PV}"

inherit desktop java-pkg-2 java-pkg-simple junit5 optfeature xdg

DESCRIPTION="Feature-filled Bittorrent client based on Azureus"
HOMEPAGE="https://www.biglybt.com"
SRC_URI="https://github.com/BiglySoftware/BiglyBT/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/BiglyBT-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

CP_DEPEND="
	>=dev-java/bcprov-1.80:0
	dev-java/commons-cli:0
	dev-java/swt:0[cairo]
"

# Due to removal of AENameServiceDescriptor it would fail to start under jdk:1.8
# StartServer ERROR: unable to bind to 127.0.0.1:6880 listening for passed torrent info: \
# sun.net.spi.nameservice.NameServiceDescriptor: Provider com.biglybt.core.util.spi.AENameServiceDescriptor not found
#
# NOTE: BiglyBT works with [headless-awt]
DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*
	test? ( dev-java/assertj-core:3 )
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( README.md ChangeLog.txt )

PATCHES=(
	"${FILESDIR}"/biglybt-3.2.0.0-disable-SWTUpdateChecker.patch
	"${FILESDIR}"/biglybt-3.2.0.0-disable-shared-plugins.patch
	"${FILESDIR}"/biglybt-3.5.0.0-Entities.javadoc.patch
	"${FILESDIR}"/biglybt-3.6.0.0-disable-PluginUpdatePlugin.patch
	"${FILESDIR}"/biglybt-3.6.0.0-fix-ambiguous.patch
	"${FILESDIR}"/biglybt-3.8.0.2-unbundle-bcprov.patch #936549
)

JAVA_GENTOO_CLASSPATH_EXTRA="target/classes"
JAVA_JAR_FILENAME="BiglyBT.jar"
JAVA_MAIN_CLASS="com.${PN}.ui.Main"
JAVA_RESOURCE_DIRS=( {core,uis}/resources )	# both are needed
JAVA_SRC_DIR="uis/src" # we compile core manually to avoid bloating the jar

#  source: MethodSource [className = 'com.biglybt.core.internat.PropertyFilesTest', methodName = 'noSplitlinesInPropertyFilesForLocalizations', methodParameterTypes = '']
#  caught: java.lang.NullPointerException: Resource not found: com/biglybt/internat/MessagesBundle_he_IL.properties
#            	at org.assertj.core.util.Preconditions.checkNotNull(Preconditions.java:92)
#            	at com.biglybt.core.internat.PropertyFilesTest.noSplitlinesInPropertyFilesForLocalizations(PropertyFilesTest.java:36)
#            	at java.base/java.lang.reflect.Method.invoke(Method.java:565)
#            	at java.base/java.util.ArrayList.forEach(ArrayList.java:1604)
#            	at java.base/java.util.ArrayList.forEach(ArrayList.java:1604)
#duration: 144 ms
#  status: ✘ FAILED
JAVA_TEST_EXCLUDES=(
	com.biglybt.core.internat.PropertyFilesTest
	com.biglybt.core.WikiTest
)

JAVA_TEST_GENTOO_CLASSPATH="assertj-core-3 junit-5"
JAVA_TEST_SRC_DIR="core/src.test"

declare -r ASSET_DIR="${S}"/assets/linux
src_prepare() {
	default #780585
	rm -r core/src/org/gudy || die "removing bundled bouncycastle failed" #936549
	java-pkg-2_src_prepare

	find -type f -name ".editorconfig" -o -name ".gitignore" -delete \
		|| die "Cleaning distfile artifacts failed"

	# AENameServiceDescriptor fails to compile with jdk >= 11
	# "error: package sun.net.spi.nameservice does not exist"
	# https://github.com/BiglySoftware/BiglyBT/pull/2611
	rm -r core/src/com/biglybt/core/util/spi || die "deleting spi failed"

	# java-pkg-simple.eclass expects resources in a separate directory
	# REVIEW: instead of copying all and deleting it would be better to copy selectively
	local module
	for module in core uis; do
		cp -r ${module}/{src,resources} || die "copying source for resources failed"
		find ${module}/resources -type f -name "*.java" -delete || die "deleting java files failed"
	done
	rm -r core/resources/META-INF || die "deleting copied META-INF failed"

	# patch the desktop file
	sed -i \
		-e '/#!/d' \
		-e 's|${installer:dir.main}/||' \
		-e 's|.svg||' \
		"${ASSET_DIR}"/${PN}.desktop || die "patching desktop file failed"

	# https://github.com/BiglySoftware/BiglyBT/pull/3523
	sed -i 's/Application;//g' "${ASSET_DIR}"/${PN}.desktop || die
}

src_compile() {
	# build core classes, needed for compiling uis
	ejavac -d target/classes \
		-cp "$(java-pkg_getjars commons-cli):$(java-pkg_getjars swt):$(java-pkg_getjars bcprov)" \
		$(find core/src -type f -name "*.java")

	java-pkg-simple_src_compile

	# see top comment
	# use doc && JAVA_SRC_DIR=( {core,uis}/src ) ejavadoc
}

src_install() {
	java-pkg-simple_src_install

	doicon -s 256 "${ASSET_DIR}"/${PN}.png
	doicon -s scalable "${ASSET_DIR}"/${PN}.svg
	domenu "${ASSET_DIR}"/${PN}.desktop

	if use source; then
		java-pkg_dosrc "core/src/*"
		java-pkg_dosrc "uis/src/*"
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature_header "If you are using plugin proxies, you might want to swap them for these native packages:"
	optfeature "I2P SOCKS proxy" net-vpn/i2p net-vpn/i2pd
	optfeature "Tor SOCKS proxy" net-vpn/tor
}
