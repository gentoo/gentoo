# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# javadocs are too broken and no tests, #839681
JAVA_PKG_IUSE="source"
MAVEN_PROVIDES="com.${PN}:${PN}-core:${PV} com.${PN}:${PN}-ui:${PV}"

inherit desktop java-pkg-2 java-pkg-simple optfeature xdg

DESCRIPTION="Feature-filled Bittorrent client based on the Azureus open source project"
HOMEPAGE="https://www.biglybt.com"
SRC_URI="https://github.com/BiglySoftware/BiglyBT/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/BiglyBT-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

CP_DEPEND="
	dev-java/commons-cli:0
	dev-java/swt:4.27[cairo]
"

# Due to removal of AENameServiceDescriptor it would fail to start under jdk:1.8
# StartServer ERROR: unable to bind to 127.0.0.1:6880 listening for passed torrent info: \
# sun.net.spi.nameservice.NameServiceDescriptor: Provider com.biglybt.core.util.spi.AENameServiceDescriptor not found
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

JAVA_GENTOO_CLASSPATH_EXTRA="target/classes"
JAVA_JAR_FILENAME="BiglyBT.jar"
JAVA_MAIN_CLASS="com.${PN}.ui.Main"
JAVA_RESOURCE_DIRS=( {core,uis}/resources )	# yes, need them both
JAVA_SRC_DIR="uis/src"

PATCHES=(
	"${FILESDIR}/biglybt-3.2.0.0-disable-SWTUpdateChecker.patch"
	"${FILESDIR}/biglybt-3.2.0.0-disable-shared-plugins.patch"
	"${FILESDIR}/biglybt-3.5.0.0-Entities.javadoc.patch"
	"${FILESDIR}/biglybt-3.6.0.0-disable-PluginUpdatePlugin.patch"
	"${FILESDIR}/biglybt-3.6.0.0-fix-ambiguous.patch"
)

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	# AENameServiceDescriptor fails to compile with jdk >= 11
	# "error: package sun.net.spi.nameservice does not exist"
	# https://github.com/BiglySoftware/BiglyBT/pull/2611
	rm -r core/src/com/biglybt/core/util/spi || die

	# java-pkg-simple.eclass expects resources in a separate directory.
	cp -r core/{src,resources} || die
	rm -r core/resources/META-INF || die "deleting META-INF"
	find core/resources -type f -name '*.java' -exec rm -rf {} + || die "core deleting *.java"
	find core/resources -type f -name '.editorconfig' -exec rm -rf {} + || die "deleting .editorconfig"

	cp -r uis/{src,resources} || die
	find uis/resources -type f -name '*.java' -exec rm -rf {} + || die "uis deleting *.java"
}

src_compile() {
	# build core classes, needed for compiling uis
	ejavac -d target/classes \
		-cp "$(java-pkg_getjars commons-cli):$(java-pkg_getjars swt-4.27)" \
		$(find core/src -name "*.java") || die

	java-pkg-simple_src_compile

	# uis/src/com/biglybt/ui/swt/plugin/net/buddy/swt/BuddyPluginView.java:68:
	# uis/src/com/biglybt/ui/swt/plugin/net/buddy/swt/BuddyPluginViewChat.java:45:
	# uis/src/com/biglybt/ui/swt/plugin/net/buddy/swt/BuddyPluginViewInstance.java:75:
	# error: package com.biglybt.ui.swt.plugin.net.buddy does not exist
#	use doc && JAVA_SRC_DIR=( {core,uis}/src ) ejavadoc
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

pkg_postinst() {
	xdg_pkg_postinst

	optfeature_header "If you are using plugin proxies you might want to swap them for these native packages:"
	optfeature "I2P SOCKS proxy" net-vpn/i2p net-vpn/i2pd
	optfeature "TOR SOCKS proxy" net-vpn/tor
}
