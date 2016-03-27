# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="Online password manager and form filler that makes web browsing easier and more secure"
HOMEPAGE="https://lastpass.com/misc_download2.php"
# sadly, upstream has no versioned distfiles
DIST_MAIN=lplinux-${PV}.tar.bz2
SRC_URI="https://lastpass.com/lplinux.tar.bz2 -> ${DIST_MAIN}"

LICENSE="LastPass"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE="+chromium +chrome +opera"
RESTRICT="strip mirror" # We can't mirror it, but we can fetch it

DEPEND="app-arch/unzip"
RDEPEND="
	chrome? ( || (
		www-client/google-chrome
		www-client/google-chrome-beta
		www-client/google-chrome-unstable
	) )
	chromium? ( >=www-client/chromium-32.0.1700.102 )
	opera? ( || (
		>=www-client/opera-35.0.2066.68
		www-client/opera-beta
		www-client/opera-developer
	) )
"
REQUIRED_USE="|| ( chrome chromium opera )"

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
	doexe "${S}"/$bin

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
		"path": "${LASTPASS_EXEDIR}/$bin",
		"type": "stdio",
		"allowed_origins": [
			"chrome-extension://hdokiejnpimakedhajhdlcegeplioahd/",
			"chrome-extension://debgaelkhoipmbjnhpoblmbacnmmgbeg/",
			"chrome-extension://hnjalnkldgigidggphhmacmimbdlafdo/",
			"chrome-extension://hgnkdfamjgnljokmokheijphenjjhkjc/"
		]
	}
	EOF

	local mydirs=( )
	use chromium && mydirs+=( /etc/chromium )
	use chrome || use opera && mydirs+=( /etc/opt/chrome )
	for d in ${mydirs[@]}; do
		insinto ${d}/policies/managed
		doins "${T}"/lastpass_policy.json
		insinto ${d}/native-messaging-hosts
		doins "${T}"/com.lastpass.nplastpass.json
	done

}

pkg_postinst() {
	einfo "This package only installs the binary plugins needed by the extension."
	einfo "Visit the link(s) below for your browser to install the extension itself:"
	use chrome || use chromium && einfo $'\t'"Chrome/Chromium: https://lastpass.com/dl/inline/?full=1"
	use opera && einfo $'\t'"Opera: https://lastpass.com/dl/"
}
