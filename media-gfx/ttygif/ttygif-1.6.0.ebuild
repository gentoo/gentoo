# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Convert terminal recordings to animated gifs"
HOMEPAGE="https://github.com/icholy/ttygif"
SRC_URI="https://github.com/icholy/ttygif/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( LICENSE README.md )

PATCHES=(
	"${FILESDIR}/ldflags-support.patch"
)

RDEPEND="
	app-misc/ttyrec
	media-gfx/imagemagick
	x11-apps/xwd
"

src_compile() {
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -DVERSION='\"${PV}\"' -DOS_LINUX" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin "${PN}"
	einstalldocs
}
