# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="CharisSIL"
inherit font

DESCRIPTION="Serif typeface for Roman and Cyrillic languages"
HOMEPAGE="https://software.sil.org/charis/"
SRC_URI="https://software.sil.org/downloads/r/charis/${MY_PN}-${PV}.zip -> ${P}.zip
	compact? ( https://software.sil.org/downloads/r/charis/${MY_PN}Compact-${PV}.zip )"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 s390 sparc x86 ~x64-macos"
IUSE="compact"

BDEPEND="app-arch/unzip"

# DOCS=( OFL-FAQ.txt documentation/* )

FONT_SUFFIX="ttf"

src_prepare() {
	default
	if use compact; then
		mv "${WORKDIR}"/${MY_PN}Compact-${PV}/*.${FONT_SUFFIX} . || die
	fi
}
