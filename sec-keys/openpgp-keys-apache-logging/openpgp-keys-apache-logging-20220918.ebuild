# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by logging.apache.org"
HOMEPAGE="https://logging.apache.org/log4j/2.x/download.html"
SRC_URI="https://www.apache.org/dist/logging/KEYS -> ${P}-KEYS.asc"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc64 x86"

S="${WORKDIR}"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - logging.apache.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
