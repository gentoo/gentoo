# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A simple tool to retrieve the X screensaver state"
HOMEPAGE="https://tools.suckless.org/x/xssstate"
SRC_URI="https://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXScrnSaver
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.20130103-gentoo.patch
	"${FILESDIR}"/${PN}-1.1-libdir.patch #732450
)

src_compile() {
	emake CC="$(tc-getCC)" LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}"/usr \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"

	dodoc README xsidle.sh
	doman ${PN}.1
}
