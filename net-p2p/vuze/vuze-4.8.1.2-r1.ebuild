# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/vuze/vuze-4.8.1.2-r1.ebuild,v 1.6 2015/04/18 12:46:17 pacho Exp $

EAPI=5

JAVA_PKG_IUSE="source"

inherit eutils fdo-mime java-pkg-2 java-ant-2 versionator

MY_PV=$(replace_all_version_separators "")

PATCHSET_VER="4.5.0.2"
PATCHSET_DIR="${PN}-${PATCHSET_VER}-gentoo-patches"
PATCHSET="${PATCHSET_DIR}.tar.bz2"
SRC_TARBALL="Vuze_${MY_PV}_source.zip"

DESCRIPTION="BitTorrent client in Java, formerly called Azureus"
HOMEPAGE="http://www.vuze.com/"
SRC_URI="mirror://sourceforge/azureus/${PN}/Vuze_${MY_PV}/${SRC_TARBALL}
	mirror://gentoo/${PATCHSET}"
LICENSE="GPL-2 BSD"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

# bundles parts of commons-lang, but modified
# bundles parts of http://www.programmers-friend.org/
RDEPEND="
	dev-java/json-simple:0
	dev-java/bcprov:1.40
	>=dev-java/commons-cli-1.0:1
	>=dev-java/log4j-1.2.8:0
	>=dev-java/swt-3.7.2-r1:3.7[cairo]
	>=virtual/jre-1.5"

DEPEND="${RDEPEND}
	app-arch/unzip
	dev-util/desktop-file-utils
	>=virtual/jdk-1.5"

PDEPEND="~net-p2p/vuze-coreplugins-${PV}"

src_unpack() {
	unpack ${PATCHSET}
	mkdir "${S}" && cd "${S}" || die
	unpack ${SRC_TARBALL}
	# this is no longer needed
	rm "${WORKDIR}"/${PATCHSET_DIR}/0006-Remove-the-use-of-windows-only-Tree2-widget.patch || die
}

java_prepare() {
	# build.xml disappeared from 4.4.0.0 although it was there in 4.3.1.4
	# hopefully that's just a packaging mistake
	[[ -f build.xml ]] && die "upstream has build.xml again, don't overwrite"
	cp "${FILESDIR}"/build.xml . || die "failed to copy build.xml"

	EPATCH_FORCE="yes" EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/${PATCHSET_DIR}/

	### Removes OS X files and entries.
	rm -rf "org/gudy/azureus2/platform/macosx" \
		   "org/gudy/azureus2/ui/swt/osx" || die

	### Removes Windows files.
	rm -rf ./org/gudy/azureus2/ui/swt/win32/Win32UIEnhancer.java || die

	### Removes test files.
	rm -rf org/gudy/azureus2/ui/console/multiuser/TestUserManager.java || die

	### Removes bouncycastle (we use our own bcprov).
	rm -rf "org/bouncycastle" || die

	### Removes bundled json
	rm -rf "org/json" || die

	### The Tree2 file does not compile against Linux SWT and is used only on Windows.
	### It's runtime-conditional use is thus patched out in the patchset.
	rm -rf "org/eclipse" || die

	mkdir -p build/libs || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="swt-3.7,bcprov-1.40,json-simple,log4j,commons-cli-1"

src_compile() {
	local mem
	use amd64 && mem="320"
	use x86   && mem="192"
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
	ewarn "updates to shared components and then collisions on updates via ebuilds"

	elog "Vuze has been formerly called Azureus and many references to the old name remain."
	elog
	elog "After running Vuze for the first time, configuration"
	elog "options will be placed in '~/.azureus/gentoo.config'."
	elog "If you need to change some startup options, you should"
	elog "modify this file, rather than the startup script."
	elog "Using this config file you can start the console UI."
	elog

	if ! has_version dev-java/swt:3.7[webkit]; then
		elog
		elog "Your dev-java/swt:3.7 was built without webkit support. Features such as Vuze HD Network will not work."
		elog "Rebuild swt with USE=webkit (needs net-libs/webkit-gtk:2) to use these features."
	fi

	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
