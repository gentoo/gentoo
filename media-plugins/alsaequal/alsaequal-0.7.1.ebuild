# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib-minimal toolchain-funcs

DESCRIPTION="A real-time adjustable equalizer plugin for ALSA"
HOMEPAGE="https://github.com/bassdr/alsaequal"
SRC_URI="https://github.com/bassdr/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	media-plugins/caps-plugins[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -Wall -fPIC -DPIC" \
		LD="$(tc-getCC)" \
		LDFLAGS="${LDFLAGS} -shared" \
		Q= \
		SND_PCM_LIBS="-lasound" \
		SND_CTL_LIBS="-lasound"
}

multilib_src_install() {
	insinto /usr/$(get_libdir)/alsa-lib
	doins *.so
}
