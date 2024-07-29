# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="BSD-licensed implementation of rsync"
HOMEPAGE="https://www.openrsync.org/"

if [[ ${PV} == *_p* ]] ; then
	MY_COMMIT="f50d0f8204ea18306a0c29c6ae850292ea826995"
	SRC_URI="https://github.com/kristapsdz/openrsync/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${MY_COMMIT}
else
	SRC_URI="https://github.com/kristapsdz/openrsync/archive/refs/tags/VERSION_$(ver_rs 3 _).tar.gz -> ${P}.tar.gz"
fi

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.0_p20220508-extern-stdint-include.patch
	"${FILESDIR}"/${PN}-0.5.0_p20220508-musl-include.patch
)

src_configure() {
	tc-export CC

	local confargs=(
		PREFIX="${EPREFIX}"/usr
		MANDIR="${EPREFIX}"/usr/share/man
	)

	edo ./configure "${confargs[@]}"
}

src_compile() {
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}
