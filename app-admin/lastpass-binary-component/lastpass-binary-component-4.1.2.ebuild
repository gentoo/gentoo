# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Binary component required by the LastPass Password Manager browser extension"
HOMEPAGE="https://helpdesk.lastpass.com/downloading-and-installing/#h5"
# sadly, upstream has no versioned distfiles
SRC_URI="https://lastpass.com/lplinux.tar.bz2 -> ${P}.tar.bz2"

LICENSE="LastPass"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
RESTRICT="strip mirror" # We can't mirror it, but we can fetch it

RDEPEND="
	!!app-admin/lastpass
"

LASTPASS_EXEDIR=/opt/lastpass/

QA_PREBUILT="
	${LASTPASS_EXEDIR}nplastpass*
"

S="${WORKDIR}/lplinux"

src_install() {
	# This is based on the upstream installer script that's in the tarball
	bin=nplastpass
	use amd64 && bin="${bin}64"
	exeinto ${LASTPASS_EXEDIR}
	doexe "${S}"/${bin}

	cat >"${T}"/lastpass_policy.json <<-EOF || die
	{
		"ExtensionInstallSources": [
			"https://lastpass.com/*",
			"https://*.lastpass.com/*",
			"https://d1jxck0p3rkj0.cloudfront.net/lastpass/*"
		]
	}
	EOF
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

	for d in /etc/chromium /etc/opt/chrome; do
		insinto ${d}/policies/managed
		doins "${T}"/lastpass_policy.json
		insinto ${d}/native-messaging-hosts
		doins "${T}"/com.lastpass.nplastpass.json
	done

}

pkg_postinst() {
	einfo "This package only installs the components required by the browser extension."
	einfo "Visit the links below for your browser to install the extension itself:"
	einfo "Chrome/Chromium: https://lastpass.com/dl/inline/?full=1"
	einfo "Opera: https://lastpass.com/dl/"
}
