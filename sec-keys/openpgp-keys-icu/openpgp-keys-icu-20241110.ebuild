# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# If a key isn't in KEYS on master, check the release branch too.
# See https://unicode-org.atlassian.net/browse/ICU-22959.
MY_COMMIT="9e68dceba9994dfc5b11d8e9c4987b0d323f6d46"
DESCRIPTION="OpenPGP keys used by ICU"
HOMEPAGE="https://icu.unicode.org/download/verification"
# https://github.com/unicode-org/icu/blob/main/KEYS
SRC_URI="https://raw.githubusercontent.com/unicode-org/icu/${MY_COMMIT}/KEYS -> ${P}-KEYS.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - icu.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
