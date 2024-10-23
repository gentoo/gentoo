# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="OPUS codec and supporting files for asterisk"
HOMEPAGE="https://docs.asterisk.org/Configuration/Codec-Opus/"

AST_PV="$(ver_cut 1-2)"
MY_PV="$(ver_rs 2 _)"

SRC_URI="https://downloads.digium.com/pub/telephony/codec_opus/asterisk-${AST_PV}/x86-64/codec_opus-${MY_PV}-x86_64.tar.gz"

S="${WORKDIR}"

LICENSE="Digium"
SLOT="0/${AST_PV}"
KEYWORDS="-* ~amd64"
RESTRICT="mirror strip"

RDEPEND="=net-misc/asterisk-${PV%%.*}*"

pkg_setup() {
	QA_FLAGS_IGNORED="/usr/$(get_libdir)/asterisk/modules/codec_opus.so"
	QA_PREBUILT="${QA_FLAGS_IGNORED}"
}

src_install() {
	local arch=x86_64

	dodoc codec_opus-${MY_PV}-${arch}/README
	insinto /usr/$(get_libdir)/asterisk/modules/
	doins "codec_opus-${MY_PV}-${arch}/codec_opus.so"

	insinto /var/lib/asterisk/documentation/thirdparty
	doins "codec_opus-${MY_PV}-${arch}/codec_opus_config-en_US.xml"
}
