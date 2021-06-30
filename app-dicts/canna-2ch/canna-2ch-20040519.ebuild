# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cannadic

DESCRIPTION="Japanese Canna dictionary for 2channelers"
HOMEPAGE="http://omaemona.sourceforge.net/packages/Canna"
SRC_URI="https://dev.gentoo.org/~naota/files/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="canna"

BDEPEND="canna? ( app-i18n/canna )"

CANNADICS=( 2ch )
DICSDIRFILE="${FILESDIR}"/052ch.dics.dir

src_compile() {
	# Anthy users do not need binary dictionary
	if use canna; then
		mkbindic nichan.ctd || die
	fi
}
