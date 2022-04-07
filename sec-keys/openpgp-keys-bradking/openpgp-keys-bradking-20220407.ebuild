# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by Brad King"
HOMEPAGE="https://cmake.org/download/"
# Mirrored from https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xcba23971357c2e6590d9efd3ec8fef3a7bfb4eda
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-2D2CEF1034921684.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - bradking.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
