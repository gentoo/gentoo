# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic savedconfig toolchain-funcs

COMMIT="cf0827876835721b8a253111ea6f065b6608164a"

DESCRIPTION="X11 Obstinate Window Lister"
HOMEPAGE="https://github.com/seanpringle/xowl"
SRC_URI="https://github.com/seanpringle/xowl/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXinerama
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-${COMMIT}"

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
