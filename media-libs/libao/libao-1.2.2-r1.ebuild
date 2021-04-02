# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib multilib-minimal

DESCRIPTION="The Audio Output library"
HOMEPAGE="https://www.xiph.org/ao/"
#SRC_URI="https://downloads.xiph.org/releases/ao/${P}.tar.gz"
#SRC_URI="https://git.xiph.org/?p=libao.git;a=snapshot;h=refs/tags/${PV};sf=tgz -> ${P}.tar.gz"
SRC_URI="https://github.com/xiph/libao/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="alsa nas mmap pulseaudio"

RDEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	nas? ( >=media-libs/nas-1.9.4[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-implicit.patch
)

src_prepare() {
	default
	sed -i "s:/lib:/$(get_libdir):g" ao.m4 || die
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-arts
		--disable-esd
		--disable-static
		$(use_enable alsa alsa)
		$(use_enable mmap alsa-mmap)
		$(use_enable nas)
		$(use_enable pulseaudio pulse)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" docdir="${EPREFIX}/usr/share/doc/${PF}/html" install
}

multilib_src_install_all() {
	dodoc AUTHORS CHANGES README TODO

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
