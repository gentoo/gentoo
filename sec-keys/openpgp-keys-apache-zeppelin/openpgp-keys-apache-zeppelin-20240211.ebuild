# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by zeppelin.apache.org"
HOMEPAGE="https://downloads.apache.org/zeppelin/"
SRC_URI="https://downloads.apache.org/zeppelin/KEYS -> ${P}-KEYS.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - zeppelin.apache.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
