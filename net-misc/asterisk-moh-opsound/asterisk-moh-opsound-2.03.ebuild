# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

DESCRIPTION="asterisk moh music"
HOMEPAGE="http://www.asterisk.org/"
CODECS="alaw g722 g729 +gsm siren7 siren14 sln16 ulaw wav"

SRC_URI=""
for c in ${CODECS}; do
	SRC_URI+=" ${c#+}? ( http://downloads.asterisk.org/pub/telephony/sounds/releases/${PN}-${c#+}-${PV}.tar.gz )"
done

IUSE="${CODECS}"
LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=net-misc/asterisk-1.4"

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

	diropts -m 0770 -o asterisk -g asterisk
	insopts -m 0660 -o asterisk -g asterisk

	dodir /var/lib/asterisk/moh
	insinto /var/lib/asterisk/moh
	doins -r .

}

pkg_postinst() {
	local c has_once_codec=

	for c in ${CODECS}; do
			use ${c#+} && has_one_codec=1
	done

	[ -n "${has_one_codec}" ] || ewarn "You have none of the codec use flags (${CODECS}) set.  You need to have at least one set in order for this package to be useful."
}
