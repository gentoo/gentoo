# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Tool for building Expert Systems (native version)"
HOMEPAGE="http://www.clipsrules.net/"

CLPN="clips_core_source_$(ver_cut 1)$(ver_cut 2)"
SRC_URI="https://sourceforge.net/projects/clipsrules/files/CLIPS/${PV}/${CLPN}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${CLPN}/core"

LICENSE="public-domain"
KEYWORDS="amd64 ~x86"
SLOT="0"

PATCHES=( "${FILESDIR}/${PN}-makefile-remove_hardcoded.patch" )

src_prepare() {
	tc-export AR CC
	default
}

src_compile() {
	emake -f makefile
}

src_install() {
	dobin clips
	dolib.a libclips.a
}
