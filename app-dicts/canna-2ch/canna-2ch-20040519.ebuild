# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cannadic

DESCRIPTION="Japanese Canna dictionary for 2channelers"
HOMEPAGE="http://omaemona.sourceforge.net/packages/Canna"
SRC_URI="https://dev.gentoo.org/~naota/files/${P}.tar.gz"
#SRC_URI="http://omaemona.sourceforge.net/packages/Canna/2ch.t"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 hppa ~ia64 ppc ppc64 sparc x86"
IUSE="canna"

DEPEND="canna? ( app-i18n/canna )"
S="${WORKDIR}/${PN}"

CANNADICS="2ch"
DICSDIRFILE="${FILESDIR}/052ch.dics.dir"

src_compile() {
	# Anthy users do not need binary dictionary
	if use canna; then
		mkbindic nichan.ctd || die
	fi
}
