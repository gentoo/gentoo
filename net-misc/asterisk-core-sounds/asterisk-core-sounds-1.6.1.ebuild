# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Core sounds for asterisk"
HOMEPAGE="http://www.asterisk.org/"
MY_L10N="^en en_AU en_GB es fr it ja ru sv" # ^ is used to indicate to the loops below to NOT set this as an optional
CODECS="alaw g722 g729 +gsm siren7 siren14 sln16 ulaw wav"

SRC_URI=""
IUSE=""
for c in ${CODECS}; do
	[[ "${c}" != +* ]] && IUSE+=" ${c}"
done
for l in ${MY_L10N}; do
	[[ "${l}" != ^* ]] && IUSE+=" l10n_${l//_/-}" && SRC_URI+=" l10n_${l//_/-}? ("
	for c in ${CODECS}; do
		[[ "${c}" != +* ]] &&
		SRC_URI+=" ${c#+}? ( http://downloads.asterisk.org/pub/telephony/sounds/releases/${PN}-${l#^}-${c#+}-${PV}.tar.gz )" ||
		SRC_URI+=" http://downloads.asterisk.org/pub/telephony/sounds/releases/${PN}-${l#^}-${c#+}-${PV}.tar.gz"
	done
	[[ "${l}" = ^* ]] || SRC_URI+=" )"
done

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

S="${WORKDIR}"

RDEPEND="!<net-misc/asterisk-extra-sounds-1.5.2"

src_unpack() {
	local ar
	local c

	for ar in ${A}; do
		l="${ar#${PN}-}"
		l=${l%%-*}
		c="${ar#${PN}-*-}"
		c=${c%%-*}
		ebegin "Unpacking ${c} audio files for \"${l}\""
			[ -d "${WORKDIR}/${l}" ] || mkdir "${WORKDIR}/${l}" || die "Error creating unpack directory"
			tar xf "${DISTDIR}/${ar}" -C "${WORKDIR}/${l}" || die "Error unpacking ${ar}"
		eend $?
	done
}

src_install() {
	local l
	local pf
	for l in ${MY_L10N}; do
		if [[ "${l}" = ^* ]] || use l10n_${l//_/-}; then
			l="${l#^}"
			dodoc ${l}/${PN#asterisk-}-${l}.txt
			rm ${l}/${PN#asterisk-}-${l}.txt
			for pf in CHANGES CREDITS LICENSE; do
				dodoc ${l}/${pf}-${PN%-sounds}-${l}-${PV}
				rm ${l}/${pf}-${PN%-sounds}-${l}-${PV}
			done
		fi
	done

	diropts -m 0755 -o root -g root
	insopts -m 0644 -o root -g root

	ebegin "Installing audio files"
		dodir /var/lib/asterisk/sounds
		insinto /var/lib/asterisk/sounds
		doins -r .
	eend $?
}
