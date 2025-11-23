# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by logging.apache.org"
HOMEPAGE="https://logging.apache.org/log4j/2.x/download.html"
SRC_URI="https://downloads.apache.org/logging/KEYS -> ${P}-KEYS.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - logging.apache.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
