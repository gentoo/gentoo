# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	# https://pcre2project.github.io/pcre2/project/security/
	'A95536204A3BB489715231282A98E77EB6F24CA8:nwilson:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Nicholas Wilson"
HOMEPAGE="https://github.com/NWilson"
# gh lacks a subuid + sigs
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-A95536204A3BB489715231282A98E77EB6F24CA8.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
