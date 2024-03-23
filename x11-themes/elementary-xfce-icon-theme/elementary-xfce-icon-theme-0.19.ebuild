# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg toolchain-funcs

MY_P="${PN%-icon-theme}-${PV}"
DESCRIPTION="Elementary icons forked from upstream, extended and maintained for Xfce"
HOMEPAGE="https://github.com/shimmerproject/elementary-xfce"
SRC_URI="https://github.com/shimmerproject/elementary-xfce/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="public-domain GPL-1 GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

BDEPEND="
	media-gfx/optipng
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3"

src_prepare() {
	sed -i -e 's:-Werror -O0 -pipe:${CFLAGS} ${CPPFLAGS} ${LDFLAGS}:' \
		svgtopng/Makefile || die
	default
}

src_configure() {
	# custom script
	./configure --prefix="${EPREFIX}/usr" || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default
	# delete dangling doc links
	find -L "${D}" -type l -delete || die
}
