# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/lastpass/lastpass-3.1.61.ebuild,v 1.4 2014/10/19 06:41:17 robbat2 Exp $

EAPI=5
inherit eutils

DESCRIPTION="Online password manager and form filler that makes web browsing easier and more secure"
HOMEPAGE="https://lastpass.com/misc_download2.php"
# sadly, upstream has no versioned distfiles
MAINDISTFILE=lplinux.tar.bz2
SRC_URI="
	https://lastpass.com/${MAINDISTFILE}
	https://lastpass.com/lpchrome_linux.crx
	firefox? ( https://lastpass.com/lp_linux.xpi )"

LICENSE="LastPass"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE="+chromium +firefox +chrome"
RESTRICT="strip mirror" # We can't mirror it, but we can fetch it

DEPEND=""
RDEPEND="
	chrome? ( || (
		www-client/google-chrome
		www-client/google-chrome-beta
		www-client/google-chrome-unstable
	) )
	chromium? ( >=www-client/chromium-32.0.1700.102 )
	firefox? ( www-client/firefox )"
REQUIRED_USE="|| ( firefox chromium chrome )"

LASTPASS_EXEDIR=/opt/lastpass/

QA_PREBUILT="
	${LASTPASS_EXEDIR}nplastpass*
	/usr/lib*/nsbrowser/plugins/libnplastpass*.so
	/usr/lib*/firefox/browser/extensions/support@lastpass.com/platform/Linux_x86_64-gcc3/components/lpxpcom_x86_64.so
	/usr/lib*/firefox/browser/extensions/support@lastpass.com/platform/Linux_x86-gcc3/components/lpxpcom.so
"

S="${WORKDIR}"

src_unpack() {
	unpack ${MAINDISTFILE}
	mkdir -p "${S}"/crx || die
	# bug #524864: strip Chrome CRX header
	# otherwise the unzip warning can be fatal in some cases
	dd bs=306 skip=1 if="${DISTDIR}"/lpchrome_linux.crx of="${T}"/lpchrome_linux.zip 2>/dev/null || die
	unzip -qq -o "${T}"/lpchrome_linux.zip -d "${S}"/crx || die
}

src_install() {
	# This is based on the upstream installer script that's in the tarball
	bin=nplastpass
	use amd64 && bin="${bin}64"
	exeinto ${LASTPASS_EXEDIR}
	doexe "${S}"/$bin

	# despite the name, this piece seems used by both firefox+chrome
	exeinto /usr/$(get_libdir)/nsbrowser/plugins
	doexe "${S}"/crx/lib${bin}.so

	cat >"${T}"/lastpass_policy.json <<-EOF
	{
		"ExtensionInstallSources": [
			"https://lastpass.com/*",
			"https://*.lastpass.com/*",
			"https://*.cloudfront.net/lastpass/*"
		]
	}
	EOF
	cat >"${T}"/com.lastpass.nplastpass.json <<-EOF
	{
		"name": "com.lastpass.nplastpass",
		"description": "LastPass",
		"path": "${LASTPASS_EXEDIR}/$bin",
		"type": "stdio",
		"allowed_origins": [
			"chrome-extension://hdokiejnpimakedhajhdlcegeplioahd/",
			"chrome-extension://debgaelkhoipmbjnhpoblmbacnmmgbeg/",
			"chrome-extension://hnjalnkldgigidggphhmacmimbdlafdo/"
		]
	}
	EOF

	if use chromium; then
		insinto /etc/chromium/policies/managed
		doins "${T}"/lastpass_policy.json
		insinto /etc/opt/chrome/native-messaging-hosts/
		doins "${T}"/com.lastpass.nplastpass.json
	fi
	if use chrome; then
		insinto /etc/opt/chrome/policies/managed/
		doins "${T}"/lastpass_policy.json
		insinto /etc/chromium/native-messaging-hosts
		doins "${T}"/com.lastpass.nplastpass.json
	fi

	if use firefox; then
		d="$D/usr/$(get_libdir)/firefox/browser/extensions/support@lastpass.com"
		mkdir -p $d || die
		unzip -qq -o "${DISTDIR}/lp_linux.xpi" -d "$d" || die
	fi

}

pkg_postinst() {
	einfo "Visit https://lastpass.com/dl/inline/?full=1 to finish installing for Chrome/Chromium/Firefox"
}
