# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by mongo-cxx-driver"
HOMEPAGE="https://pgp.mongodb.com/"
SRC_URI="
	https://pgp.mongodb.com/cpp-driver.pub -> ${P}.pub
"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - mongo-cxx-driver.gpg < <(cat "${files[@]/#/${DISTDIR}/}")
}
