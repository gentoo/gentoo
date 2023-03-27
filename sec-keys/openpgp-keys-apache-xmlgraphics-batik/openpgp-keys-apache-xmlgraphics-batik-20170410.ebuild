# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by xmlgraphics.apache.org/batik"
HOMEPAGE="https://xmlgraphics.apache.org/batik/download.html"
SRC_URI="https://downloads.apache.org/xmlgraphics/batik/KEYS -> ${P}-KEYS.asc"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

S="${WORKDIR}"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - xmlgraphics-batik.apache.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
