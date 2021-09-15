# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CHROMIUM_LANGS="
	af
	am
	ar
	az
	be
	bg
	bn
	ca
	cs
	da
	de
	de-CH
	el
	en-GB
	en-US
	eo
	es
	es-419
	es-PE
	et
	eu
	fa
	fi
	fil
	fr
	fy
	gd
	gl
	gu
	he
	hi
	hr
	hu
	hy
	id
	io
	is
	it
	ja
	jbo
	ka
	kab
	kn
	ko
	ku
	lt
	lv
	mk
	ml
	mr
	ms
	nb
	nl
	nn
	pa
	pl
	pt-BR
	pt-PT
	ro
	ru
	sc
	sk
	sl
	sq
	sr
	sr-Latn
	sv
	sw
	ta
	te
	th
	tr
	uk
	vi
	zh-CN
	zh-TW
"

inherit chromium-2 desktop unpacker xdg

VIVALDI_PN="${PN/%vivaldi/vivaldi-stable}"
VIVALDI_HOME="opt/${PN}"
DESCRIPTION="A browser for our friends"
HOMEPAGE="https://vivaldi.com/"

if [[ ${PV} = *_p* ]]; then
	DEB_REV="${PV#*_p}"
else
	DEB_REV=1
fi

KEYWORDS="-* amd64 ~arm ~arm64"
VIVALDI_BASE_URI="https://downloads.vivaldi.com/${VIVALDI_PN#vivaldi-}/${VIVALDI_PN}_${PV%_p*}-${DEB_REV}_"

RE="\bamd64\b"; [[ ${KEYWORDS} =~ ${RE} ]] && SRC_URI+=" amd64? ( ${VIVALDI_BASE_URI}amd64.deb )"
RE="\barm\b"; [[ ${KEYWORDS} =~ ${RE} ]] && SRC_URI+=" arm? ( ${VIVALDI_BASE_URI}armhf.deb )"
RE="\barm64\b"; [[ ${KEYWORDS} =~ ${RE} ]] && SRC_URI+=" arm64? ( ${VIVALDI_BASE_URI}arm64.deb )"
RE="\bx86\b"; [[ ${KEYWORDS} =~ ${RE} ]] && SRC_URI+=" x86? ( ${VIVALDI_BASE_URI}i386.deb )"

LICENSE="Vivaldi"
SLOT="0"
IUSE="proprietary-codecs widevine"
RESTRICT="bindist mirror"

RDEPEND="
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/speex
	net-print/cups
	sys-apps/dbus
	sys-libs/libcap
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango[X]
	proprietary-codecs? ( media-video/ffmpeg:0/56.58.58[chromium(-)] )
	widevine? ( www-plugins/chrome-binary-plugins )
"

QA_PREBUILT="*"
S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	# Rename docs directory to our needs.
	mv usr/share/doc/{${VIVALDI_PN},${PF}}/ || die

	# Decompress the docs.
	gunzip usr/share/doc/${PF}/changelog.gz || die

	# The appdata directory is deprecated.
	mv usr/share/{appdata,metainfo}/ || die

	# Remove cron job for updating from Debian repos.
	rm etc/cron.daily/${PN} ${VIVALDI_HOME}/cron/${PN} || die
	rmdir etc/{cron.daily/,} ${VIVALDI_HOME}/cron/ || die

	# Remove scripts that will most likely break things.
	rm ${VIVALDI_HOME}/update-{ffmpeg,widevine} || die

	pushd ${VIVALDI_HOME}/locales > /dev/null || die
	rm ja-KS.pak || die # No flag for Kansai as not in IETF list.
	chromium_remove_language_paks
	popd > /dev/null || die

	if use proprietary-codecs; then
		rm ${VIVALDI_HOME}/lib/libffmpeg.so || die
		rmdir ${VIVALDI_HOME}/lib || die
	fi

	eapply_user
}

src_install() {
	mv */ "${D}" || die
	dosym /${VIVALDI_HOME}/${PN} /usr/bin/${PN}
	fperms 4711 /${VIVALDI_HOME}/vivaldi-sandbox

	local logo size
	for logo in "${ED}"/${VIVALDI_HOME}/product_logo_*.png; do
		size=${logo##*_}
		size=${size%.*}
		newicon -s "${size}" "${logo}" ${PN}.png
	done

	if use proprietary-codecs; then
		dosym ../../usr/$(get_libdir)/chromium/libffmpeg.so \
			  /${VIVALDI_HOME}/libffmpeg.so.$(ver_cut 1-2)
	fi

	if use widevine; then
		dosym ../../usr/$(get_libdir)/chromium-browser/WidevineCdm \
			  /${VIVALDI_HOME}/WidevineCdm
	else
		rm "${ED}"/${VIVALDI_HOME}/WidevineCdm || die
	fi

	[[ ${PN} = vivaldi-snapshot ]] &&
		dosym ${PN} /${VIVALDI_HOME}/vivaldi
}
