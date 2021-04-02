# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal

MY_P="${P/sdl-/SDL_}"
DESCRIPTION="Graphics drawing primitives library for SDL"
HOMEPAGE="http://www.ferzkopp.net/joomla/content/view/19/14/"
SRC_URI="http://www.ferzkopp.net/Software/SDL_gfx-2.0/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="doc cpu_flags_x86_mmx"

RDEPEND=">=media-libs/libsdl-1.2.15-r4[video,${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog README )

src_prepare() {
	default
	sed -i -e 's/-O //' configure.in || die
	mv configure.in configure.ac || die
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable cpu_flags_x86_mmx mmx) \
		--disable-static
}

#multilib_src_install() {
#	emake DESTDIR="${D}" install
#}

multilib_src_install_all() {
	einstalldocs

	if use doc ; then
		docinto html
		dodoc -r Docs/*
	fi

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
