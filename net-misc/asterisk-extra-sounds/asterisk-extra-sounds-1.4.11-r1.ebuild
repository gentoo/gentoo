# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Extra sounds for asterisk"
HOMEPAGE="http://www.asterisk.org/"
MY_L10N=(^en fr) # ^ is used to indicate to the loops below to NOT set this as an optional
CODECS=(alaw g722 g729 +gsm siren7 siren14 sln16 ulaw wav)

SRC_URI=""
IUSE="${CODECS[*]}"
REQUIRED_USE="|| ( ${CODECS[*]#+} )"
for l in "${MY_L10N[@]}"; do
	[[ ${l} != ^* ]] && IUSE+=" l10n_${l}" && SRC_URI+=" l10n_${l}? ("
	for c in "${CODECS[@]}"; do
		SRC_URI+=" ${c#+}? ( http://downloads.asterisk.org/pub/telephony/sounds/releases/${PN}-${l#^}-${c#+}-${PV}.tar.gz )"
	done
	[[ ${l} == ^* ]] || SRC_URI+=" )"
done

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND=">=net-misc/asterisk-1.4"

S="${WORKDIR}"

src_unpack() {
	local ar
	for ar in ${A}; do
		local l="${ar#${PN}-}"
		l=${l%%-*}
		mkdir -p "${WORKDIR}/${l}" || die
		cd "${WORKDIR}/${l}" || die
		unpack "${ar}"
	done
}

src_install() {
	local l
	for l in "${MY_L10N[@]}"; do
		if [[ ${l} == ^* ]] || use "l10n_${l}"; then
			l="${l#^}"
			dodoc "${l}/CHANGES-${PN%-sounds}-${l}-${PV}" \
				"${l}/${PN#asterisk-}-${l}.txt"
			rm "${l}/CHANGES-${PN%-sounds}-${l}-${PV}" \
				"${l}/${PN#asterisk-}-${l}.txt" || die
		fi
	done

	diropts -m 0770 -o asterisk -g asterisk
	insopts -m 0660 -o asterisk -g asterisk
	insinto /var/lib/asterisk/sounds
	doins -r .
}
