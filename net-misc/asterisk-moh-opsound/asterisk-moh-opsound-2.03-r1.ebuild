# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="asterisk moh music"
HOMEPAGE="http://www.asterisk.org/"
CODECS="alaw g722 g729 +gsm siren7 siren14 sln16 ulaw wav"

SRC_URI=""
for c in ${CODECS}; do
	SRC_URI+=" ${c#+}? ( http://downloads.asterisk.org/pub/telephony/sounds/releases/${PN}-${c#+}-${PV}.tar.gz )"
done

IUSE="${CODECS}"
REQUIRED_USE="|| ( ${CODECS//+/} )"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"

S="${WORKDIR}"

src_install() {
	local c

	for c in ${CODECS}; do
		if use ${c#+}; then
			for pf in CREDITS LICENSE CHANGES; do
				dodoc "$pf-$PN-${c#+}"
				rm "$pf-$PN-${c#+}"
			done
		fi
	done

	diropts -m 0755 -o root -g root
	insopts -m 0644 -o root -g root

	dodir /var/lib/asterisk/moh
	insinto /var/lib/asterisk/moh
	doins -r .
}
