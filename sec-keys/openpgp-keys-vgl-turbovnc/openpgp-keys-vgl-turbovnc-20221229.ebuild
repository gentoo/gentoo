# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign VGL TurboVNC"
HOMEPAGE="https://turbovnc.org/Downloads/DigitalSignatures"
SRC_URI="https://www.turbovnc.org/key/VGL-GPG-KEY -> ${P}"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - vgl-turbovnc.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
