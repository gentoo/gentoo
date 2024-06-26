# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="G.729 codec and supporting files for asterisk"
HOMEPAGE="https://www.sangoma.com/asterisk/software/g729-codec/"

AST_PV="$(ver_cut 1-2)"
MY_PV="$(ver_rs 2 _)"

SRC_URI="x86? (
	https://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-x86_32.tar.gz
	https://downloads.digium.com/pub/register/x86-32/register -> astregister-x86_32
	https://downloads.digium.com/pub/register/x86-32/asthostid -> asthostid-x86_32
)
amd64? (
	https://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-64/codec_g729a-${MY_PV}-x86_64.tar.gz
	https://downloads.digium.com/pub/register/x86-64/register -> astregister-x86_64
	https://downloads.digium.com/pub/register/x86-64/asthostid -> asthostid-x86_64
)"

LICENSE="Digium"
SLOT="0/${AST_PV}"
KEYWORDS="-* amd64 x86"

RDEPEND="=net-misc/asterisk-$(ver_cut 1)*"

RESTRICT="mirror strip"

S="${WORKDIR}"

pkg_setup() {
	QA_FLAGS_IGNORED="/usr/$(get_libdir)/asterisk/modules/codec_g729a.so"
	QA_PREBUILT="${QA_FLAGS_IGNORED}
		/usr/sbin/asthostid
		/usr/sbin/astregister"
}

src_unpack() {
	local dfile

	for dfile in ${A}; do
		[[ "${dfile}" = *.tar.gz ]] && unpack "${dfile}"
		cp "${DISTDIR}/${dfile}" "${WORKDIR}/" || die "Error copying ${dfile} to ${WORKDIR}"
	done
}

src_install() {
	local binsuffix

	if use x86; then
		binsuffix=x86_32
	elif use amd64; then
		binsuffix=x86_64
	fi

	newsbin astregister-${binsuffix} astregister
	newsbin asthostid-${binsuffix} asthostid

	dodoc codec_g729a-${MY_PV}-${binsuffix}/README
	insinto usr/$(get_libdir)/asterisk/modules/
	doins "codec_g729a-${MY_PV}-${binsuffix}/codec_g729a.so"
}

pkg_postinst() {
	einfo "Please note that Digium's register utility has been installed as astregister"
}
