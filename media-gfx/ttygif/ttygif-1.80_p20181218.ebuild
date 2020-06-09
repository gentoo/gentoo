# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vcs-snapshot toolchain-funcs

# Commit Date: Dec 18th 2018
COMMIT="362bc381c1c2449509e732d68f07656caf46b420"

DESCRIPTION="Convert terminal recordings to animated gifs"
HOMEPAGE="https://github.com/icholy/ttygif"
SRC_URI="https://github.com/icholy/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"

DOCS=( LICENSE README.md )

PATCHES=( "${FILESDIR}/ldflags-support.patch" )

RDEPEND="
	x11-apps/xwd
	app-misc/ttyrec
	media-gfx/imagemagick"

src_compile() {
	emake CC=$(tc-getCC) \
		CFLAGS="${CFLAGS} -DVERSION='\"${PV}\"' -DOS_LINUX" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin "${PN}"
	einstalldocs
}
