# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by https://jackrabbit.apache.org"
HOMEPAGE="https://jackrabbit.apache.org/jcr/downloads.html"
SRC_URI="https://downloads.apache.org/jackrabbit/KEYS -> ${P}-keys.asc"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc64"

S="${WORKDIR}"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - jackrabbit.apache.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
