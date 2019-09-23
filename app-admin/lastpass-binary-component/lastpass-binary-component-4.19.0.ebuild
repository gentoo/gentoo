# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Binary component required by the LastPass Password Manager browser extension"
HOMEPAGE="https://helpdesk.lastpass.com/downloading-and-installing/#h5"
# sadly, upstream has no versioned distfiles
SRC_URI="https://download.cloud.lastpass.com/linux/lplinux.tar.bz2 -> ${P}.tar.bz2"

LICENSE="LastPass"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist strip mirror" # We can't mirror it, but we can fetch it

LASTPASS_EXEDIR=/opt/lastpass/

QA_PREBUILT="
	${LASTPASS_EXEDIR}nplastpass*
"

S="${WORKDIR}"

src_install() {
	# This is based on the upstream installer script that's in the tarball
	bin=nplastpass
	use amd64 && bin="${bin}64"
	exeinto ${LASTPASS_EXEDIR}
	doexe "${S}"/${bin}

	# Generate the policy file for Chrome/Chromium/Opera
	cat >"${T}"/lastpass_policy.json <<-EOF || die
	{
		"ExtensionInstallSources": [
			"https://lastpass.com/*",
			"https://*.lastpass.com/*",
			"https://d1jxck0p3rkj0.cloudfront.net/lastpass/*"
		]
	}
	EOF
	# Install the policy file for Chrome/Chromium/Opera
	for d in /etc/chromium /etc/opt/chrome; do
		insinto ${d}/policies/managed
		doins "${T}"/lastpass_policy.json
	done

	# Generate the app manifest for Chrome/Opera
	cat >"${T}"/com.lastpass.nplastpass.json <<-EOF || die
	{
		"name": "com.lastpass.nplastpass",
		"description": "LastPass",
		"path": "${LASTPASS_EXEDIR}${bin}",
		"type": "stdio",
		"allowed_origins": [
			"chrome-extension://hdokiejnpimakedhajhdlcegeplioahd/",
			"chrome-extension://debgaelkhoipmbjnhpoblmbacnmmgbeg/",
			"chrome-extension://hnjalnkldgigidggphhmacmimbdlafdo/",
			"chrome-extension://hgnkdfamjgnljokmokheijphenjjhkjc/"
		]
	}
	EOF
	# Install the app manifest for Chrome/Opera
	# https://developer.chrome.com/apps/nativeMessaging
	# https://dev.opera.com/extensions/message-passing/
	insinto /etc/opt/chrome/native-messaging-hosts
	doins "${T}"/com.lastpass.nplastpass.json

	# Generate the app manifest for Chromium
	cat >"${T}"/com.lastpass.nplastpass.json <<-EOF || die
	{
		"name": "com.lastpass.nplastpass",
		"description": "LastPass",
		"path": "${LASTPASS_EXEDIR}${bin}",
		"type": "stdio",
		"allowed_origins": [
			"chrome-extension://hdokiejnpimakedhajhdlcegeplioahd/",
			"chrome-extension://debgaelkhoipmbjnhpoblmbacnmmgbeg/",
			"chrome-extension://hgnkdfamjgnljokmokheijphenjjhkjc/"
		]
	}
	EOF
	# Install the app manifest for Chromium
	# https://developer.chrome.com/apps/nativeMessaging
	insinto /etc/chromium/native-messaging-hosts/
	doins "${T}"/com.lastpass.nplastpass.json

	# Generate the app manifest for Firefox
	cat >"${T}"/com.lastpass.nplastpass.json <<-EOF || die
	{
		"name": "com.lastpass.nplastpass",
		"description": "LastPass",
		"path": "${LASTPASS_EXEDIR}${bin}",
		"type": "stdio",
		"allowed_extensions": [
			"support@lastpass.com"
		]
	}
	EOF
	# Install the app manifest for Firefox
	# https://developer.mozilla.org/en-US/Add-ons/WebExtensions/Native_manifests#Manifest_location
	insinto /usr/lib/mozilla/native-messaging-hosts/
	doins "${T}"/com.lastpass.nplastpass.json
}

pkg_postinst() {
	einfo "This package only installs the components required by the browser extension."
	einfo "Visit the links below for your browser to install the extension itself:"
	einfo "Chrome/Chromium: https://lastpass.com/dl/inline/?full=1"
	einfo "Firefox: https://lastpass.com/lastpassffx/"
	einfo "Opera: https://lastpass.com/dl/"
	einfo
	einfo "Chrome, Chromium and Opera users need to manually enable the binary component."
	einfo "For more info, visit: https://lastpass.com/support.php?cmd=showfaq&id=5576"
}
