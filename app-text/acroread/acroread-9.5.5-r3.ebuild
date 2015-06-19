# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/acroread/acroread-9.5.5-r3.ebuild,v 1.3 2015/06/14 16:28:20 ulm Exp $

EAPI=5

inherit eutils gnome2-utils nsplugins

DESCRIPTION="Adobe's PDF reader"
SRC_URI="http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/${PV}/enu/AdbeRdr${PV}-1_i486linux_enu.tar.bz2"
HOMEPAGE="http://www.adobe.com/products/reader/"

LICENSE="Adobe"
KEYWORDS="-* amd64 x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="html ldap nsplugin"
# asian fonts from separate package:
IUSE+=" linguas_zh_CN linguas_zh_TW linguas_ja linguas_ko"

RESTRICT="strip mirror"

DEPEND=""
RDEPEND="
	dev-libs/atk[abi_x86_32(-)]
	dev-libs/glib:2[abi_x86_32(-)]
	dev-libs/libxml2[abi_x86_32(-)]
	dev-libs/openssl:0.9.8[abi_x86_32(-)]
	media-libs/fontconfig[abi_x86_32(-)]
	virtual/glu[abi_x86_32(-)]
	>=net-dns/libidn-1.28[abi_x86_32(-)]
	sys-libs/zlib[abi_x86_32(-)]
	x11-libs/gdk-pixbuf:2[abi_x86_32(-)]
	>=x11-libs/gtk+-2.24.23:2[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/pango[abi_x86_32(-)]
	|| (
		>=x11-libs/pangox-compat-0.0.2[abi_x86_32(-)]
		<x11-libs/pango-1.31[X]
	)
	nsplugin? ( x11-libs/libXt[abi_x86_32(-)] )
	ldap? ( >=net-nds/openldap-2.4.38-r1[abi_x86_32(-)] )
	x86? ( html? (
		|| (
			www-client/firefox-bin
			www-client/firefox
			www-client/seamonkey-bin
			www-client/seamonkey
		)
	) )
	linguas_zh_CN? ( media-fonts/acroread-asianfonts[linguas_zh_CN] )
	linguas_ja? ( media-fonts/acroread-asianfonts[linguas_ja] )
	linguas_zh_TW? ( media-fonts/acroread-asianfonts[linguas_zh_TW] )
	linguas_ko? ( media-fonts/acroread-asianfonts[linguas_ko] )"

QA_EXECSTACK="
	opt/Adobe/Reader9/Reader/intellinux/bin/acroread
	opt/Adobe/Reader9/Reader/intellinux/lib/libauthplay.so.0.0.0
	opt/Adobe/Reader9/Reader/intellinux/lib/libsccore.so
	opt/Adobe/Reader9/Reader/intellinux/lib/libcrypto.so.0.9.8
	opt/Adobe/Reader9/Reader/intellinux/plug_ins/PPKLite.api
"
QA_FLAGS_IGNORED="
	opt/Adobe/Reader9/Reader/intellinux/plug_ins3d/.*.x3d
	opt/Adobe/Reader9/Reader/intellinux/lib/lib.*
	opt/Adobe/Reader9/Reader/intellinux/bin/SynchronizerApp-binary
	opt/Adobe/Reader9/Reader/intellinux/bin/acroread
	opt/Adobe/Reader9/Reader/intellinux/bin/xdg-user-dirs-update
	opt/Adobe/Reader9/Reader/intellinux/SPPlugins/ADMPlugin.apl
	opt/Adobe/Reader9/Reader/intellinux/plug_ins/AcroForm/PMP/.*.pmp
	opt/Adobe/Reader9/Reader/intellinux/plug_ins/Multimedia/MPP/.*.mpp
	opt/Adobe/Reader9/Reader/intellinux/plug_ins/.*.api
	opt/Adobe/Reader9/Reader/intellinux/sidecars/.*.DEU
	opt/Adobe/Reader9/Browser/intellinux/nppdf.so
	opt/netscape/plugins/nppdf.so
"
QA_TEXTRELS="
	opt/Adobe/Reader9/Reader/intellinux/lib/libextendscript.so
	opt/Adobe/Reader9/Reader/intellinux/lib/libsccore.so
"

INSTALLDIR=/opt

S="${WORKDIR}/AdobeReader"

# remove bundled libs to force use of system version, bug 340527
REMOVELIBS="libcrypto libssl"

pkg_setup() {
	# x86 binary package, ABI=x86
	has_multilib_profile && ABI="x86"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# lowercase tar extension required for unpack, bug 476734
	mv ./ILINXR.TAR ./ILINXR.tar || die
	mv ./COMMON.TAR ./COMMON.tar || die
	unpack ./ILINXR.tar ./COMMON.tar
}

src_prepare() {
	# remove cruft
	rm "${S}"/Adobe/Reader9/bin/UNINSTALL
	rm "${S}"/Adobe/Reader9/Browser/install_browser_plugin
	rm "${S}"/Adobe/Reader9/Resource/Support/vnd.*.desktop

	# replace some configuration sections
	for binfile in "${S}"/Adobe/Reader9/bin/* ; do
		sed -i -e '/Font-config/,+9d' \
			-e "/acrogre.conf/r ${FILESDIR}/gentoo_config" -e //N \
			"${binfile}" || die "sed configuration settings failed."
	done

	# fix erroneous Exec entry in .desktop
	sed -i \
		-e 's/^Exec=acroread[[:space:]]*$/Exec=acroread %F/' \
		-e 's/^Categories=Application;Office;Viewer;X-Red-Hat-Base;/Categories=Office;Viewer;/' \
		-e 's/^Caption=/X-Caption=/' \
		"${S}"/Adobe/Reader9/Resource/Support/AdobeReader.desktop \
		||die "sed .desktop fix failed"

	# fix braindead error in nppdf.so (bug 412051)
	sed -i 's#C:\\nppdf32Log\\debuglog\.txt#/dev/null\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00#g' \
		Adobe/Reader9/Browser/intellinux/nppdf.so || die
}

src_install() {
	local LAUNCHER="Adobe/Reader9/bin/acroread"

	# Install desktop files
	domenu Adobe/Reader9/Resource/Support/AdobeReader.desktop

	# Install commonly used icon sizes
	for res in 16x16 22x22 32x32 48x48 64x64 128x128 ; do
		insinto /usr/share/icons/hicolor/${res}/apps
		doins Adobe/Reader9/Resource/Icons/${res}/*
	done

	dodir /opt
	chown -R --dereference -L root:0 Adobe
	cp -dpR Adobe "${ED}"opt/ || die

	# remove some bundled libs
	for mylib in ${REMOVELIBS}; do
		einfo Removing bundled ${mylib}
		rm -v "${ED}"/opt/Adobe/Reader9/Reader/intellinux/lib/${mylib}*
	done

	doman Adobe/Reader9/Resource/Shell/acroread.1.gz

	if use nsplugin; then
		inst_plugin /opt/Adobe/Reader9/Browser/intellinux/nppdf.so
	else
		rm -v "${ED}"/opt/Adobe/Reader9/Browser/intellinux/nppdf.so
	fi

	dodir /opt/bin
	dosym /opt/${LAUNCHER} /opt/bin/${LAUNCHER/*bin\/}

	# NOTE -- this is likely old and broken and should be removed...
	# We need to set a MOZILLA_COMP_PATH for seamonkey and firefox since
	# they don't install a configuration file for libgtkembedmoz.so
	# detection in /etc/gre.d/ like xulrunner did.
	if use x86 && use html; then
		for lib in /opt/{seamonkey,firefox} /usr/lib/{seamonkey,firefox,mozilla-firefox}; do
			if [[ -f ${lib}/libgtkembedmoz.so ]] ; then
				echo "MOZILLA_COMP_PATH=${lib}" >> "${ED}"${INSTALLDIR}/Adobe/Reader9/Reader/GlobalPrefs/mozilla_config
				elog "Adobe Reader depends on libgtkembedmoz.so, which I've found on"
				elog "your system in ${lib}, and configured in ${INSTALLDIR}/Adobe/Reader9/Reader/GlobalPrefs/mozilla_config."
				break # don't search any more libraries
			fi
		done
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst () {
	if use x86 && ! use html; then
		echo
		ewarn "If you want html support and/or view the Adobe Reader help you have"
		ewarn "to re-emerge acroread with USE=\"html\"."
		echo
	fi

	if use amd64; then
		if use nsplugin && ! has_version www-plugins/nspluginwrapper; then
			echo
			elog "If you're running a 64bit browser you may also want to install"
			elog "\"www-plugins/nspluginwrapper\" to be able to use the Adobe Reader"
			elog "browser plugin."
		fi
		elog ""
		elog "If you find that Adobe Reader doesn't match your desktop's theme, you"
		elog "may want to re-emerge the relevant gtk theme package with"
		elog "USE=\"abi_x86_32\" enabled."
	fi

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
