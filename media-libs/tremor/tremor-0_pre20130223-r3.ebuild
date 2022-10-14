# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="A fixed-point version of the Ogg Vorbis decoder (also known as libvorbisidec)"
HOMEPAGE="https://wiki.xiph.org/Tremor"
SRC_URI="https://dev.gentoo.org/~ssuominen/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="low-accuracy"

RDEPEND=">=media-libs/libogg-1.3.0:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-out-of-bounds-write.patch
	"${FILESDIR}"/${P}-autoconf.patch
	"${FILESDIR}"/${P}-pkgconfig.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf $(use_enable low-accuracy)
}

multilib_src_install_all() {
	HTML_DOCS=( doc/. )
	einstalldocs

	find "${ED}" -name '*.la' -type f -delete || die
}
