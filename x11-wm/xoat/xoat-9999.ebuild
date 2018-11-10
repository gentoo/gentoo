# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic git-r3 savedconfig toolchain-funcs

DESCRIPTION="X Obstinate Asymmetric Tiler"
HOMEPAGE="https://github.com/seanpringle/xoat"
EGIT_REPO_URI="https://github.com/seanpringle/xoat"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

DEPEND="
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXinerama
"
RDEPEND="
	${DEPEND}
	!savedconfig? ( x11-misc/dmenu )
"

src_prepare() {
	default
	restore_config config.h
}

src_configure() {
	tc-export CC PKG_CONFIG
}

src_compile() {
	XOAT_COMPILE=(
		${CC} -o ${PN} ${PN}.c ${CFLAGS} -std=c99 ${LDFLAGS}
		$(${PKG_CONFIG} --cflags --libs x11 xinerama xft)
	)
	echo ${XOAT_COMPILE[@]}
	${XOAT_COMPILE[@]} || die
}

src_install() {
	dobin xoat
	dodoc status xinitrc xoat.md xoatrc
	doman xoat.1
	save_config config.h
}
