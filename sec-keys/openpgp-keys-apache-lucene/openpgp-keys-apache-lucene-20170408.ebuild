# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by lucene.apache.org"
HOMEPAGE="https://lucene.apache.org/core/downloads.html"
SRC_URI="https://archive.apache.org/dist/lucene/java/KEYS -> ${P}-KEYS.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - lucene.apache.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
