# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="OPUS codec and supporting files for asterisk"
HOMEPAGE="https://wiki.asterisk.org/wiki/display/AST/Codec+Opus"

AST_PV="$(ver_cut 1-2)"
MY_PV="$(ver_rs 2 _)"

SRC_URI="amd64? (
	https://downloads.digium.com/pub/telephony/codec_opus/asterisk-${AST_PV}/x86-64/codec_opus-${MY_PV}-x86_64.tar.gz
)
x86? (
	https://downloads.digium.com/pub/telephony/codec_opus/asterisk-${AST_PV}/x86-32/codec_opus-${MY_PV}-x86_32.tar.gz
)"

LICENSE="Digium"
SLOT="0/${AST_PV}"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="=net-misc/asterisk-${PV%%.*}*"

RESTRICT="mirror strip"

S="${WORKDIR}"

pkg_setup() {
	QA_FLAGS_IGNORED="/usr/$(get_libdir)/asterisk/modules/codec_opus.so"
	QA_PREBUILT="${QA_FLAGS_IGNORED}"
}

src_install() {
	local arch

	if use x86; then
		arch=x86_32
	elif use amd64; then
		arch=x86_64
	fi

	dodoc codec_opus-${MY_PV}-${arch}/README
	insinto /usr/$(get_libdir)/asterisk/modules/
	doins "codec_opus-${MY_PV}-${arch}/codec_opus.so"

	insinto /var/lib/asterisk/documentation/thirdparty
	doins "codec_opus-${MY_PV}-${arch}/codec_opus_config-en_US.xml"
}
