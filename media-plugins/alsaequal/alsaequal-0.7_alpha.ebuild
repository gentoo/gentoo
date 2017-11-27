# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils multilib toolchain-funcs multilib-minimal

DESCRIPTION="A real-time adjustable equalizer plugin for ALSA"
HOMEPAGE="https://github.com/bassdr/alsaequal"
SRC_URI="https://github.com/bassdr/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}]
	>=media-plugins/caps-plugins-0.9.15[${MULTILIB_USEDEP}]
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224-r3
					!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}
DOCS=( README )

src_unpack() {
	unpack ${A}
	S="$(pwd)/${PN}-${PV/_/-}"
}

src_prepare() {
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
		SND_CTL_LIBS="-lasound" || die
}

multilib_src_install() {
	exeinto /usr/$(get_libdir)/alsa-lib
	doexe *.so || die
}
