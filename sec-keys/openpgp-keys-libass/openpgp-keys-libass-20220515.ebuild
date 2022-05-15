# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign libass releases"
HOMEPAGE="https://github.com/libass/libass/blob/master/MAINTAINERS"
SRC_URI="https://github.com/astiob.gpg -> ${P}-astiob.gpg
	https://github.com/TheOneric.gpg -> ${P}-TheOneric.gpg
	https://github.com/rcombs.gpg -> ${P}-rcombs.gpg"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S="${WORKDIR}"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - libass.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
