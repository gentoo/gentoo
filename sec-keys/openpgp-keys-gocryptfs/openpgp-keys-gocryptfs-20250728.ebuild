# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign gocryptfs"
HOMEPAGE="https://nuetzlich.net/"
SRC_URI="https://nuetzlich.net/gocryptfs-signing-key.pub -> ${P}.pub"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - gocryptfs.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
