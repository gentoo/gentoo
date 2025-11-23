# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by httpcomponents-core.hc.apache.org"
HOMEPAGE="https://downloads.apache.org/httpcomponents/httpcore/"
SRC_URI="https://downloads.apache.org/httpcomponents/httpcore/KEYS -> ${P}-KEYS.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - httpcomponents-core.hc.apache.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
