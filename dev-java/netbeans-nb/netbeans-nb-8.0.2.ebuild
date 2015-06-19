# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/netbeans-nb/netbeans-nb-8.0.2.ebuild,v 1.5 2015/05/21 09:51:53 ago Exp $

EAPI="4"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans IDE Branding"
HOMEPAGE="http://netbeans.org/"
SLOT="8.0"
SOURCE_URL="http://download.netbeans.org/netbeans/8.0.2/final/zip/netbeans-8.0.2-201411181905-src.zip"
SRC_URI="${SOURCE_URL}
	http://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.0.2-build.xml.patch.bz2
	http://dev.gentoo.org/~fordfrog/distfiles/netbeans-7.0.png"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="amd64 x86"
IUSE="keychain"
S="${WORKDIR}"

CDEPEND="~dev-java/netbeans-platform-${PV}
	~dev-java/netbeans-harness-${PV}
	~dev-java/netbeans-ide-${PV}"
DEPEND="virtual/jdk:1.7
	app-arch/unzip
	${CDEPEND}
	dev-java/javahelp:0"
RDEPEND=">=virtual/jdk-1.7
	${CDEPEND}
	keychain? (
		net-misc/keychain:0
		net-misc/x11-ssh-askpass:0
	)"

INSTALL_DIR="/usr/share/${PN}-${SLOT}"

EANT_BUILD_XML="nbbuild/build.xml"
EANT_BUILD_TARGET="rebuild-cluster create-netbeans-import finish-build"
EANT_EXTRA_ARGS="-Drebuild.cluster.name=nb.cluster.nb -Dext.binaries.downloaded=true"
EANT_FILTER_COMPILER="ecj-3.3 ecj-3.4 ecj-3.5 ecj-3.6 ecj-3.7"
JAVA_PKG_BSFIX="off"

src_unpack() {
	unpack $(basename ${SOURCE_URL})

	einfo "Deleting bundled jars..."
	find -name "*.jar" -type f -delete

	unpack netbeans-8.0.2-build.xml.patch.bz2
}

src_prepare() {
	einfo "Deleting bundled class files..."
	find -name "*.class" -type f | xargs rm -vf

	epatch netbeans-8.0.2-build.xml.patch
	use keychain && epatch "${FILESDIR}"/${SLOT}/keychain-support.patch

	# Support for custom patches
	if [ -n "${NETBEANS80_PATCHES_DIR}" -a -d "${NETBEANS80_PATCHES_DIR}" ] ; then
		local files=`find "${NETBEANS80_PATCHES_DIR}" -type f`

		if [ -n "${files}" ] ; then
			einfo "Applying custom patches:"

			for file in ${files} ; do
				epatch "${file}"
			done
		fi
	fi

	einfo "Symlinking external libraries..."
	java-pkg_jar-from --build-only --into javahelp/external javahelp jhall.jar jhall-2.0_05.jar

	einfo "Linking in other clusters..."
	mkdir "${S}"/nbbuild/netbeans || die
	pushd "${S}"/nbbuild/netbeans >/dev/null || die

	ln -s /usr/share/netbeans-platform-${SLOT} platform || die
	cat /usr/share/netbeans-platform-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.platform.built

	ln -s /usr/share/netbeans-harness-${SLOT} harness || die
	cat /usr/share/netbeans-harness-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.harness.built

	ln -s /usr/share/netbeans-ide-${SLOT} ide || die
	cat /usr/share/netbeans-ide-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.ide.built
	popd >/dev/null || die

	java-pkg-2_src_prepare
}

src_install() {
	pushd nbbuild/netbeans >/dev/null || die

	insinto ${INSTALL_DIR}/nb

	grep -E "/nb$" moduleCluster.properties > "${D}"/${INSTALL_DIR}/nb/moduleCluster.properties || die

	insinto ${INSTALL_DIR}
	doins -r nb
	dodoc *.txt
	dohtml *.html *.css

	insinto ${INSTALL_DIR}/bin
	doins bin/netbeans
	dosym ${INSTALL_DIR}/bin/netbeans /usr/bin/netbeans-${SLOT}
	fperms 755 ${INSTALL_DIR}/bin/netbeans

	insinto /etc/netbeans-${SLOT}
	doins etc/*
	dosym /etc/netbeans-${SLOT} ${INSTALL_DIR}/etc

	# fix paths per bug# 163483
	if [[ -e "${D}"/${INSTALL_DIR}/bin/netbeans ]]; then
		sed -i -e "s:\"\$progdir\"/../etc/:/etc/netbeans-${SLOT}/:" "${D}"/${INSTALL_DIR}/bin/netbeans
		sed -i -e "s:\"\${userdir}\"/etc/:/etc/netbeans-${SLOT}/:" "${D}"/${INSTALL_DIR}/bin/netbeans
	fi

	dodir /usr/share/icons/hicolor/32x32/apps
	dosym ${INSTALL_DIR}/nb/netbeans.png /usr/share/icons/hicolor/32x32/apps/netbeans-${SLOT}.png
	dodir /usr/share/icons/hicolor/128x128/apps
	cp "${DISTDIR}"/netbeans-7.0.png "${D}"/usr/share/icons/hicolor/128x128/apps/netbeans-${SLOT}.png || die
	dosym /usr/share/icons/hicolor/128x128/apps/netbeans-${SLOT}.png /usr/share/pixmaps/netbeans-${SLOT}.png

	popd >/dev/null || die

	make_desktop_entry netbeans-${SLOT} "Netbeans ${PV}" netbeans-${SLOT} Development

	mkdir -p  "${D}"/${INSTALL_DIR}/nb/config || die
	echo "NBGNT" > "${D}"/${INSTALL_DIR}/nb/config/productid || die
}

pkg_postinst() {
	if use keychain ; then
		einfo "You enabled keychain support, that means NetBeans will use keychain for managing"
		einfo "your keys while connecting to ssh protected repositories. If you want to load some"
		einfo "keys on NetBeans startup, create file keychain-keys.txt in your userdir"
		einfo "(~/.netbeans/${SLOT}/keychain-keys.txt) and put names of your keys in the file,"
		einfo "each key on single line, for example:"
		einfo "id_dsa"
		einfo "id_dsa_gentoo"
		einfo "If on NetBeans startup key will not be handled by keychain yet, you will be asked"
		einfo "for key password (only this time and never again). You can find more information"
		einfo "about keychain at https://wiki.gentoo.org/wiki/Keychain"
	fi
}
