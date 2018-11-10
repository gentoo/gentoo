# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic git-r3 savedconfig toolchain-funcs

DESCRIPTION="X11 Obstinate Window Lister"
HOMEPAGE="https://github.com/seanpringle/xowl"
EGIT_REPO_URI="https://github.com/seanpringle/xowl"

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
		$(${PKG_CONFIG} --cflags --libs x11 xft xinerama)
	)
	echo ${XOAT_COMPILE[@]}
	${XOAT_COMPILE[@]} || die
}

src_install() {
	dobin xowl
	dodoc xowl.md
	doman xowl.1
	save_config config.h
}
