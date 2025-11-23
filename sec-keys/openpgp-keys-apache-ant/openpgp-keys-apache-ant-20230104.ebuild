# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by ant.apache.org"
HOMEPAGE="https://ant.apache.org/srcdownload.cgi"
SRC_URI="https://downloads.apache.org/ant/KEYS -> ${P}-KEYS.asc"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

S="${WORKDIR}"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - ant.apache.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
