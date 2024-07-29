# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Framebuffer screenshot utility"
HOMEPAGE="https://github.com/GunnarMonell/fbgrab"
SRC_URI="https://github.com/GunnarMonell/fbgrab/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ppc ~ppc64 ~s390 ~sparc x86"

RDEPEND="media-libs/libpng:=
	 sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/gzip"

src_prepare() {
	default
	sed -i -e "s:-g::" Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	newman ${PN}.1.man ${PN}.1
}
