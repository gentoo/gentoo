# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Adobe PostScript drivers for Windows for use with CUPS"
HOMEPAGE="http://www.adobe.com/support/downloads/product.jsp?product=44&platform=Windows"
SRC_URI_BASE="ftp://ftp.adobe.com/pub/adobe/printerdrivers/win/1.x"
SRC_URI=""

LICENSE="AdobePS"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cups"

DEPEND="app-arch/cabextract"
RDEPEND="cups? ( >=net-print/cups-1.2 )"

IUSE_LINGUAS=( en da de es fi fr it ja ko nl no pt_BR sv zh_CN )
IUSE_FILES=( winsteng winstDan winstger winstspa winstfin winstfre winstita
	winstjpn winstkor winstdut winstnor winstbrz winstswe Winstchs ) # winstcht

IUSE_LANGS=""
IUSE_CLOSE=""
for ((X=0; X < ${#IUSE_LINGUAS[*]}; X++)); do
	IUSE="${IUSE} linguas_${IUSE_LINGUAS[X]}"
	SRC_URI="${SRC_URI} linguas_${IUSE_LINGUAS[X]}? ( ${SRC_URI_BASE}/${IUSE_FILES[X]}.exe )"
	IUSE_LANGS="${IUSE_LANGS} !linguas_${IUSE_LINGUAS[X]}? ("
	IUSE_CLOSE="${IUSE_CLOSE} )"
done
SRC_URI="${SRC_URI} ${IUSE_LANGS} ${SRC_URI_BASE}/${IUSE_FILES[0]}.exe${IUSE_CLOSE}"

S="${WORKDIR}"

pkg_setup() {
	local X L=""
	ADOBEPS_LANG=""
	for X in ${LINGUAS}; do
		if [[ " ${IUSE_LINGUAS[*]} " =~ " ${X} " ]]; then
			[ -z "${ADOBEPS_LANG}" ] && ADOBEPS_LANG="${X}"
			L="${L} ${X}"
		fi
	done
	if [ -z "${ADOBEPS_LANG}" ]; then
		L="${IUSE_LINGUAS[0]}"; ADOBEPS_LANG="${L}"
	fi
	elog "Selected languages:" ${L}
	use cups && elog "CUPS drivers language: ${ADOBEPS_LANG}"
}

src_unpack() {
	local X L
	for ((X=0; X < ${#IUSE_LINGUAS[*]}; X++)); do
		L="${IUSE_LINGUAS[X]}"
		if use linguas_${L} || [ "${L}" = "${ADOBEPS_LANG}" ]; then
			cabextract -Lq -d "${S}/${IUSE_LINGUAS[X]}" \
				"${DISTDIR}/${IUSE_FILES[X]}.exe" || die "unpack failed"
		fi
	done
}

src_install() {
	local X
	for X in ${IUSE_LINGUAS[*]}; do
		if use linguas_${X} || [ "${X}" = "${ADOBEPS_LANG}" ]; then
			# files and filenames taken from cupsaddsmb man-page
			insinto "/usr/share/${PN}/${X}"
			# Windows 2000 and higher
			doins ${X}/winxp/{ps5ui.dll,pscript.hlp,pscript.ntf,pscript5.dll}
			# Windows 95, 98, and Me
			newins ${X}/windows/adfonts.mfm  ADFONTS.MFM
			newins ${X}/windows/adobeps4.drv ADOBEPS4.DRV
			newins ${X}/windows/adobeps4.hlp ADOBEPS4.HLP
			newins ${X}/windows/iconlib.dll  ICONLIB.DLL
			newins ${X}/windows/psmon.dll    PSMON.DLL
		fi
	done
	# symlink primary language to cups drivers
	if use cups; then
		dodir /usr/share/cups/drivers
		for X in ps5ui.dll pscript.hlp pscript.ntf pscript5.dll \
			ADFONTS.MFM ADOBEPS4.DRV ADOBEPS4.HLP ICONLIB.DLL PSMON.DLL; do
			dosym "../../${PN}/${ADOBEPS_LANG}/${X}" "/usr/share/cups/drivers/${X}"
		done
	fi
}
