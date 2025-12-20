# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by spamassassin.apache.org"
HOMEPAGE="https://spamassassin.apache.org/downloads.cgi"
SRC_URI="https://downloads.apache.org/spamassassin/KEYS -> ${P}-KEYS.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - spamassassin.apache.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
