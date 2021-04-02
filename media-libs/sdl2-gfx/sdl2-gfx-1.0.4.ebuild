# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal

MY_P="${P/sdl2-/SDL2_}"
DESCRIPTION="Graphics drawing primitives library for SDL2"
HOMEPAGE="http://www.ferzkopp.net/joomla/content/view/19/14/"
SRC_URI="http://www.ferzkopp.net/Software/SDL2_gfx/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="doc cpu_flags_x86_mmx"

DEPEND=">=media-libs/libsdl2-2.0.1-r1[video,${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README )

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.4-slibtool.patch
)

src_prepare() {
	default
	mv configure.in configure.ac || die
	sed -i \
		-e 's/ -O / /' \
		configure.ac || die
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable cpu_flags_x86_mmx mmx)
		--disable-static
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs

	if use doc ; then
		docinto html
		dodoc -r Docs/html/*
	fi

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
