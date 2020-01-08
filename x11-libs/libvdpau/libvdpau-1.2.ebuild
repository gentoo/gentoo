# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VIRTUALX_REQUIRED="test"
inherit autotools flag-o-matic virtualx multilib-minimal

DESCRIPTION="VDPAU wrapper and trace libraries"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/VDPAU"
SRC_URI="https://gitlab.freedesktop.org/vdpau/${PN}/-/archive/${P}/${PN}-${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm64 x86"
IUSE="doc dri"

RDEPEND="
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	dri? ( >=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
		virtual/latex-base
		)
	dri? ( x11-base/xorg-proto )
"
S=${WORKDIR}/${PN}-${P}

src_prepare() {
	default
	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	append-cppflags -D_GNU_SOURCE
	econf \
		$(use dri || echo --disable-dri2) \
		$(use_enable doc documentation) \
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
}

multilib_src_test() {
	virtx emake check
}

multilib_src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
