# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/linuxtv-dvb-firmware/linuxtv-dvb-firmware-2009.09.19.ebuild,v 1.4 2014/05/01 12:45:50 ulm Exp $

DESCRIPTION="Firmware files needed for operation of some dvb-devices"
HOMEPAGE="http://www.linuxtv.org"

LICENSE="freedist ISC all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror bindist"

DEPEND="app-arch/unrar"
RDEPEND=""

S="${WORKDIR}"

# Files which can be fetched from linuxtv.org
PACKET_NAME=dvb-firmwares-1.tar.bz2
PACKET_SRC_URI="http://www.linuxtv.org/downloads/firmware/${PACKET_NAME}"
TEVII_NAME=Tevii_linuxdriver_0815.rar
TEVII_SRC_URI="http://tevii.com/${TEVII_NAME}"
get_dvb_firmware="${FILESDIR}/get_dvb_firmware-${PV}"
# from http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6-stable.git;a=history;f=Documentation/dvb/get_dvb_firmware

FW_USE_FLAGS=(
# packet
	"usb-a800"
	"dibusb-usb2"
	"usb-dtt200u"
	"usb-umt"
	"usb-vp702x"
	"usb-vp7045"
	"usb-wt220u"
	"dibusb-usb1"
	"or51211"
	"or51132"
	"or51132"
	"usb-dw2104"
	"usb-dw2104"
# own URL
	"ttpci"
	"bcm3510"
	"usb-wt220u"
	"usb-wt220u"
	"usb-dib0700"
	"sp887x"
	"af9005"
	"cx231xx"
	"cx18"
	"cx18"
	"cx18"
	"cx23885"
	"cx23885"
	"pvrusb2"
	"usb-bluebird"
	"tda10045"
# get_dvb_firmware
	"sp8870"
	"tda10046"
	"tda10046lifeview"
	"ttusb-dec"
	"ttusb-dec"
	"ttusb-dec"
	"opera1"
	"opera1"
	"vp7041"
	"nxt200x"
	"mpc718"
	"usb-af9015"
)

FW_FILES=(
# packet
	"dvb-usb-avertv-a800-02.fw"
	"dvb-usb-dibusb-6.0.0.8.fw"
	"dvb-usb-dtt200u-01.fw"
	"dvb-usb-umt-010-02.fw"
	"dvb-usb-vp702x-01.fw"
	"dvb-usb-vp7045-01.fw"
	"dvb-usb-wt220u-01.fw"
	"dvb-usb-dibusb-5.0.0.11.fw"
	"dvb-fe-or51211.fw"
	"dvb-fe-or51132-qam.fw"
	"dvb-fe-or51132-vsb.fw"
	"dvb-usb-dw2104.fw"
	"dvb-fe-cx24116.fw"
# own URL
	"dvb-ttpci-01.fw"
	"dvb-fe-bcm3510-01.fw"
	"dvb-usb-wt220u-02.fw"
	"dvb-usb-wt220u-fc03.fw"
	"dvb-usb-dib0700-1.20.fw"
	"dvb-fe-sp887x.fw"
	"af9005.fw"
	"v4l-cx231xx-avcore-01.fw"
	"v4l-cx23418-apu.fw"
	"v4l-cx23418-cpu.fw"
	"v4l-cx23418-dig.fw"
	"v4l-cx23885-avcore-01.fw"
	"v4l-cx23885-enc.fw"
	"v4l-cx25840.fw"
	"dvb-usb-bluebird-01.fw"
	"dvb-fe-tda10045.fw"
# get_dvb_firmware
	"dvb-fe-sp8870.fw"
	"dvb-fe-tda10046.fw"
	"dvb-fe-tda10046.fw"
	"dvb-ttusb-dec-2000t.fw"
	"dvb-ttusb-dec-2540t.fw"
	"dvb-ttusb-dec-3000s.fw"
	"dvb-usb-opera1-fpga-01.fw"
	"dvb-usb-opera-01.fw"
	"dvb-vp7041-2.422.fw"
	"dvb-fe-nxt2004.fw"
	"dvb-cx18-mpc718-mt352.fw"
	"dvb-usb-af9015.fw"
)

FW_GET_PARAMETER=(
# packet
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
# own URL
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
	"-"
# get_dvb_firmware
	"sp8870"
	"tda10046"
	"tda10046lifeview"
	"dec2000t"
	"dec2540t"
	"dec3000s"
	"opera1"
	"-"
	"vp7041"
	"nxt2004"
	"mpc718"
	"af9015"
)

FW_URLS=(
# packet
	"${PACKET_SRC_URI}"
	"${PACKET_SRC_URI}"
	"${PACKET_SRC_URI}"
	"${PACKET_SRC_URI}"
	"${PACKET_SRC_URI}"
	"${PACKET_SRC_URI}"
	"${PACKET_SRC_URI}"
	"${PACKET_SRC_URI}"
	"${PACKET_SRC_URI}"
	"${PACKET_SRC_URI}"
	"${PACKET_SRC_URI}"
	"${TEVII_SRC_URI}"
	"${TEVII_SRC_URI}"
# own URL
	"http://www.escape-edv.de/endriss/firmware/dvb-ttpci-01.fw-fc2624"
	"http://www.linuxtv.org/downloads/firmware/dvb-fe-bcm3510-01.fw"
	"http://www.linuxtv.org/downloads/firmware/dvb-usb-wt220u-02.fw"
	"http://home.arcor.de/efocht/dvb-usb-wt220u-fc03.fw"
	"http://www.wi-bw.tfh-wildau.de/~pboettch/home/files/dvb-usb-dib0700-1.20.fw"
	"http://peterdamen.com/dvb-fe-sp887x.fw"
	"http://ventoso.org/luca/af9005/af9005.fw"
	"http://linuxtv.org/downloads/firmware/v4l-cx231xx-avcore-01.fw"
	"http://linuxtv.org/downloads/firmware/v4l-cx23418-apu.fw"
	"http://linuxtv.org/downloads/firmware/v4l-cx23418-cpu.fw"
	"http://linuxtv.org/downloads/firmware/v4l-cx23418-dig.fw"
	"http://linuxtv.org/downloads/firmware/v4l-cx23885-avcore-01.fw"
	"http://linuxtv.org/downloads/firmware/v4l-cx23885-enc.fw"
	"http://linuxtv.org/downloads/firmware/v4l-cx25840.fw"
	"http://linuxtv.org/downloads/firmware/dvb-usb-bluebird-01.fw"
	"http://www.fireburn.co.uk/dvb-fe-tda10045.fw"
# get_dvb_firmware
	"http://2.download.softwarepatch.pl/1619edb0dcb493dd5337b94a1f79c3f6/tt_Premium_217g.zip"
	"http://www.tt-download.com/download/updates/219/TT_PCI_2.19h_28_11_2006.zip"
	"http://www.lifeview.hk/dbimages/document/7%5Cdrv_2.11.02.zip"
	"http://hauppauge.lightpath.net/de/dec217g.exe"
	"http://hauppauge.lightpath.net/de/dec217g.exe"
	"http://hauppauge.lightpath.net/de/dec217g.exe"
	"http://www.informatik.uni-leipzig.de/~hlawit/dvb/2830SCap2.sys"
	"http://www.informatik.uni-leipzig.de/~hlawit/dvb/2830SLoad2.sys"
	"http://www.twinhan.com/files/AW/Software/TwinhanDTV2.608a.zip"
	"http://www.avermedia-usa.com/support/Drivers/AVerTVHD_MCE_A180_Drv_v1.2.2.16.zip"
	"ftp://ftp.work.acer-euro.com/desktop/aspire_idea510/vista/Drivers/Yuan%20MPC718%20TV%20Tuner%20Card%202.13.10.1016.zip"
	"http://www.ite.com.tw/EN/Services/download.ashx?file=57"
)

SRC_URI=""
NEGATIVE_USE_FLAGS=""
NEGATIVE_END_BRACKETS=""
ALL_URLS=""

for ((CARD=0; CARD < ${#FW_USE_FLAGS[*]}; CARD++)) do
	URL="${FW_URLS[CARD]}"

	if [[ -z ${URL} ]]; then
		echo "missing url for ${FW_USE_FLAGS[CARD]}"
		continue
	fi
	SRC_URI="${SRC_URI} dvb_cards_${FW_USE_FLAGS[CARD]}? ( ${URL} )"

	IUSE="${IUSE} dvb_cards_${FW_USE_FLAGS[CARD]}"
	NEGATIVE_USE_FLAGS="${NEGATIVE_USE_FLAGS} !dvb_cards_${FW_USE_FLAGS[CARD]}? ( "
	NEGATIVE_END_BRACKETS="${NEGATIVE_END_BRACKETS} )"
	ALL_URLS="${ALL_URLS} ${URL}"

	GET_PARAM="${FW_GET_PARAMETER[CARD]}"
	if [[ ${GET_PARAM} != "-" ]]; then
		# all firmwares extracted by get_dvb_firmware need unzip
		DEPEND="${DEPEND} dvb_cards_${FW_USE_FLAGS[CARD]}? ( app-arch/unzip )"
	fi
done

SRC_URI="${SRC_URI} ${NEGATIVE_USE_FLAGS} ${ALL_URLS} ${NEGATIVE_END_BRACKETS}"

DEPEND="${DEPEND}
	${NEGATIVE_USE_FLAGS}
	app-arch/unzip
	${NEGATIVE_END_BRACKETS}"

install_dvb_card() {
	if [[ -z ${DVB_CARDS} ]]; then
		# install (almost) all firmware files
		# do not install this one due to conflicting filenames
		[[ "${1}" != "tda10046lifeview" ]]
	else
		# Check if this flag is set
		use dvb_cards_${1}
	fi
}

pkg_setup() {
	#echo SRC_URI=${SRC_URI}
	#echo DEPEND=${DEPEND}
	if has tda1004x ${DVB_CARDS}; then
		eerror
		eerror "DVB_CARDS flag tda1004x has been split into"
		eerror "tda10045, tda10046 and tda10046lifeview".
		eerror
		eerror "But beware that you cannot enable tda10046 and"
		eerror "tda10046lifeview at the same time."
	fi

	if [[ -z ${DVB_CARDS} ]]; then
		elog
		elog "DVB_CARDS is not set, installing all available firmware files."
		elog "To save bandwidth please consider setting the DVB_CARDS variable"
		elog "in ${ROOT%/}/etc/make.conf. This way only the firmwares you own"
		elog "the hardware will be installed."
	fi
	# according to http://devmanual.gentoo.org/general-concepts/use-flags/index.html
	# we should not die here. However, there is no sensible fallback choice to make
	# because the user may have either the one or the other. WYGIWYG
	if use dvb_cards_tda10046 && use dvb_cards_tda10046lifeview; then
		eerror
		eerror "You cannot have both tda10046 and tda10046lifeview in DVB_CARDS"
		eerror "because of colliding firmware filenames (dvb-fe-tda10046.fw)."
		eerror "Sorry."
		die "Conflicting values for DVB_CARDS set."
	fi
	elog
	elog "List of possible card-names to use for DVB_CARDS:"
	echo ${FW_USE_FLAGS[*]}| tr ' ' '\n' | sort | uniq | fmt \
	| while read line; do
		elog "   ${line}"
	done
	elog
	elog "If you need another firmware file and want it included create a bug"
	elog "at bugs.gentoo.org."
	elog "In case some firmware sources are not fetchable please try again at"
	elog "a later time and if it still does not fetch report a bug. If there"
	elog "is no alternative source or an update to the firmware available we"
	elog "have to remove it from the ebuild and you are on your own."
}

src_unpack() {
	local distfile

	# link all downloaded files to ${S}
	for distfile in ${A}; do
		[[ -L ${distfile} ]] || ln -s ${DISTDIR}/${distfile} ${distfile}
	done

	# unpack firmware-packet
	if has ${PACKET_NAME} ${A}; then
		unpack ${PACKET_NAME}
	fi

	# unpack tevii packet
	if has ${TEVII_NAME} ${A}; then
		unpack ${TEVII_NAME}
	fi

	if [[ -z ${DVB_CARDS} ]] || use dvb_cards_mpc718 ; then
		mv Yuan%20MPC718%20TV%20Tuner%20Card%202.13.10.1016.zip "Yuan MPC718 TV Tuner Card 2.13.10.1016.zip"
	fi
	if [[ -z ${DVB_CARDS} ]] || use dvb_cards_ttpci ; then
		mv dvb-ttpci-01.fw-fc2624 dvb-ttpci-01.fw
	fi

	if [[ -z ${DVB_CARDS} ]] || use dvb_cards_usb-dw2104 ; then
		mv tevii_linuxdriver_0815/fw/dvb-usb-s650.fw dvb-usb-dw2104.fw
		mv tevii_linuxdriver_0815/fw/dvb-fe-cx24116.fw ./
	fi

	local script_v=${PV}

	# Adjust temp-dir of get_dvb_firmware
	sed "${FILESDIR}"/get_dvb_firmware-${script_v} \
		-e "s#/tmp#${T}#g" > get_dvb_firmware
	chmod a+x get_dvb_firmware

	# extract the firmware-files
	for ((CARD=0; CARD < ${#FW_USE_FLAGS[*]}; CARD++)) do
		install_dvb_card ${FW_USE_FLAGS[CARD]} || continue

		GET_PARAM=${FW_GET_PARAMETER[CARD]}
		if [[ ${GET_PARAM} != "-" ]]; then
			[[ -f ${FW_FILES[CARD]} ]] && ewarn "Already existing: ${FW_FILES[CARD]}"
			elog "Extracting ${FW_FILES[CARD]}"
			./get_dvb_firmware ${GET_PARAM}
		fi
	done
}

src_install() {
	insinto /lib/firmware

	for ((CARD=0; CARD < ${#FW_USE_FLAGS[*]}; CARD++)) do
		if install_dvb_card ${FW_USE_FLAGS[CARD]}; then
			local file=${FW_FILES[CARD]}
			[[ -f ${file} ]] || die "File ${file} does not exist!"
			doins ${file}
		fi
	done
}
