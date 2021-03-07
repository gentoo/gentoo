# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2 xdg-utils desktop

MY_PV=$(ver_rs 1- "")
MY_SRC="Vuze_${MY_PV}"

DESCRIPTION="BitTorrent client in Java, formerly called Azureus"
HOMEPAGE="http://www.vuze.com/"
SRC_URI="mirror://sourceforge/azureus/${PN}/${MY_SRC}/${MY_SRC}_source.zip"
LICENSE="GPL-2 BSD"

SLOT="0"
KEYWORDS="amd64 ppc64 x86"

# bundles parts of http://www.programmers-friend.org/
# bundles bcprov - 1.37 required but not in the tree
CDEPEND="
	dev-java/log4j:0
	dev-java/swt:3.8[cairo]
	dev-java/commons-cli:1
	dev-java/json-simple:0
	dev-java/commons-lang:2.1"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8"

DEPEND="
	${CDEPEND}
	app-arch/unzip
	dev-util/desktop-file-utils
	>=virtual/jdk-1.8"

PDEPEND="~net-p2p/vuze-coreplugins-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.3.0.0-java5.patch
	"${FILESDIR}"/${PN}-5.3.0.0-remove-classpath.patch
	"${FILESDIR}"/${PN}-5.3.0.0-disable-shared-plugins.patch
	"${FILESDIR}"/${PN}-5.7.2.0-disable-osx.patch
	"${FILESDIR}"/${PN}-5.3.0.0-disable-updaters.patch
	"${FILESDIR}"/${P}-unbundle-commons.patch
	"${FILESDIR}"/${PN}-5.3.0.0-unbundle-json.patch
	"${FILESDIR}"/${PN}-5.6.0.0-commons-lang-entities.patch
#	"${FILESDIR}"/${P}-use-jdk-cipher-only.patch # bcprov
)

src_unpack() {
	mkdir -p "${S}" || die
	cd "${S}" || die
	unpack ${A}

	# build.xml disappeared from 4.4.0.0 although it was there in 4.3.1.4
	if [[ -f build.xml ]]; then
		die "upstream has build.xml again, don't overwrite"
	fi
	cp "${FILESDIR}"/build.xml "${S}" || die "failed to copy build.xml"
}

src_prepare() {
	# upstream likes randomly changing a subset of files to CRLF every release
	edos2unix $(find "${S}" -type f -name "*.java")

	default

	# OSX / Windows
	rm "${S}"/org/gudy/azureus2/ui/swt/osx/CarbonUIEnhancer.java || die
	rm "${S}"/org/gudy/azureus2/ui/swt/osx/Start.java || die
	rm "${S}"/org/gudy/azureus2/ui/swt/win32/Win32UIEnhancer.java || die

	# Tree2 file does not compile on linux
	rm -rf "${S}"/org/eclipse || die
	# Bundled apache
	rm -rf "${S}"/org/apache || die
	# Bundled json
	rm -rf "${S}"/org/json || die
	# Bundled bcprov
	# currently disabled - requires bcprov 1.37
	#rm -rf "${S}"/org/bouncycastle || die

	rm -rf "${S}"/org/gudy/azureus2/ui/console/multiuser/TestUserManager.java || die
	mkdir -p "${S}"/build/libs || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="swt-3.8,json-simple,log4j,commons-cli-1 commons-lang-2.1"

src_compile() {
	local mem
	use amd64 && mem="320"
	use x86   && mem="256"
	use ppc   && mem="192"
	use ppc64 && mem="256"
	use sparc && mem="320"
	export ANT_OPTS="-Xmx${mem}m"
	java-pkg-2_src_compile

	# bug #302058 - build.xml excludes .txt but upstream jar has it...
	jar uf dist/Azureus2.jar ChangeLog.txt || die
}

src_install() {
	java-pkg_dojar dist/Azureus2.jar
	dodoc ChangeLog.txt

	java-pkg_dolauncher "${PN}" \
		--main org.gudy.azureus2.ui.common.Main -pre "${FILESDIR}/${PN}-4.1.0.0-pre" \
		--java_args '-Dazureus.install.path=/usr/share/vuze/ ${JAVA_OPTIONS}' \
		--pkg_args '--ui=${UI}'
	dosym vuze /usr/bin/azureus

	# https://bugs.gentoo.org/show_bug.cgi?id=204132
	java-pkg_register-environment-variable MOZ_PLUGIN_PATH /usr/lib/nsbrowser/plugins

	newicon "${S}"/org/gudy/azureus2/ui/icons/a32.png vuze.png
	domenu "${FILESDIR}"/${PN}.desktop

	use source && java-pkg_dosrc "${S}"/{com,edu,org}
}

pkg_postinst() {
	ewarn "Running Vuze as root is not supported and may result in untracked"
	ewarn "updates to shared components and then collisions on updates"
	echo
	elog "Vuze was formerly called Azureus and many references to the old name remain."
	elog
	elog "After running Vuze for the first time, configuration options will be"
	elog "placed in '~/.azureus/gentoo.config'."
	elog
	elog "If you need to change some startup options, you should modify this file"
	elog "rather than the startup script.  You can enable the console UI by"
	elog "editing this config file."
	echo
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
