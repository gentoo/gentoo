# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit versionator multilib

DESCRIPTION="G.729 codec and supporting files for asterisk"
HOMEPAGE="http://store.digium.com/productview.php?product_code=G729CODEC"

BENCH_PV=1.0.8

AST_PV=11.0
MY_PV=$(replace_version_separator 2 _)

SRC_URI="x86? (
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-athlon_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-athlon_xp_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-barcelona_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-c3_2_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-c3_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-core2_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-generic_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-i686_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-k6_3_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-nocona_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-opteron_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-opteron_sse3_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-pentium3m_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-pentium4m_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-pentium_m_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-32/codec_g729a-${MY_PV}-prescott_32.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/benchg729/x86-32/benchg729-${BENCH_PV}-x86_32 -> benchg729-x86_32
	http://downloads.digium.com/pub/register/x86-32/register -> astregister-x86_32
	http://downloads.digium.com/pub/register/x86-32/asthostid -> asthostid-x86_32
)
amd64? (
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-64/codec_g729a-${MY_PV}-barcelona_64.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-64/codec_g729a-${MY_PV}-core2_64.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-64/codec_g729a-${MY_PV}-generic_64.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-64/codec_g729a-${MY_PV}-nocona_64.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-64/codec_g729a-${MY_PV}-opteron_64.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/asterisk-${AST_PV}/x86-64/codec_g729a-${MY_PV}-opteron_sse3_64.tar.gz
	http://downloads.digium.com/pub/telephony/codec_g729/benchg729/x86-64/benchg729-${BENCH_PV}-x86_64 -> benchg729-x86_64
	http://downloads.digium.com/pub/register/x86-64/register -> astregister-x86_64
	http://downloads.digium.com/pub/register/x86-64/asthostid -> asthostid-x86_64
)
http://g729.uls.co.za/static/g729-stats-collector/collect-g729-stats.sh"

LICENSE="Digium"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND} =net-misc/asterisk-11*"

RESTRICT="mirror strip"

QA_FLAGS_IGNORED_amd64="usr/lib64/asterisk/modules/codec_g729a.so usr/sbin/benchg729"
QA_FLAGS_IGNORED_x86="usr/lib/asterisk/modules/codec_g729a.so usr/sbin/benchg729"
QA_PREBUILT="usr/sbin/benchg729 usr/sbin/asthostid usr/sbin/astregister"

S="${WORKDIR}"

src_prepare() {
	local binsuffix
	local b

	if use x86; then
		binsuffix=x86_32
	elif use amd64; then
		binsuffix=x86_64
	else
		die "Ebuild only functions for x86 and amd64."
	fi

	for b in astregister asthostid benchg729; do
		cp "${DISTDIR}/${b}-${binsuffix}" "${WORKDIR}/${b}" || die
		fperms 755 ${b}
	done

	cp "${DISTDIR}/collect-g729-stats.sh" "${WORKDIR}" || die
}

src_compile() {
	./benchg729 | tee benchdata
	variant=$(sed -nre "s/^Recommended flavor for this system is '([^']*)'.*/\1/p" < benchdata)
	[ -d codec_g729a-${MY_PV}-${variant}_${size} ] || variant=generic
	[ -z $variant ] && variant=generic
}

src_install() {
	local size

	if use x86; then
		size=32
	elif use amd64; then
		size=64
	else
		die "Ebuild only functions for x86 and amd64."
	fi

	dosbin astregister
	dosbin asthostid
	dosbin benchg729
	dosbin collect-g729-stats.sh

	dodoc codec_g729a-${MY_PV}-${variant}_${size}/LICENSE
	dodoc codec_g729a-${MY_PV}-${variant}_${size}/README
	insinto usr/$(get_libdir)/asterisk/modules/
	doins "codec_g729a-${MY_PV}-${variant}_${size}/codec_g729a.so"
}

pkg_postinst() {
	einfo "Please note that Digium's register utility has been installed as astregister"
	einfo
	einfo "Please consider participating in the G.729 stats collection that ULS"
	einfo "is performing.  This will assist in picking better variants for more"
	einfo "processors as we gather more statistics.  All you need to do is run"
	einfo "the collect-g729-stats.sh command."
	[ "${variant}" = "generic" ] && einfo "You are using the generic flavor of the codec, in order to install a more appropriate one please install a G.729 license and remerge this package (${PN})."
}
