# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Plex Inc"
HOMEPAGE="https://www.plex.tv/"
SRC_URI="
	https://downloads.plex.tv/plex-keys/PlexSign.v2.key
		-> plexmediaserver-6EFFEB478A6559D75C7C4FE706C521790B9CFFDE.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - plexmediaserver.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
