# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib

DESCRIPTION="digital signal processing library for software-defined radios"
HOMEPAGE="https://liquidsdr.org"

LICENSE="MIT"
SLOT="0"

if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jgaeddert/liquid-dsp.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/jgaeddert/liquid-dsp/archive/v1.3.0.tar.gz -> ${P}.tar.gz"
fi

IUSE="static-libs"

DEPEND="sci-libs/fftw:3.0="
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	#without this rather odd looking bit, it installs libraries into /usr/usr/$(get_libdir)
	#what is super special is that if exec-prefix is unset, libdir is lib64...
	#but if exec-prefix is default then libdir ends up as /usr/lib64 in makefile...
	econf --exec-prefix="" --libdir="/usr/$(get_libdir)"
}

src_install() {
	default
	! use static-libs && rm "${ED}"/usr/"$(get_libdir)"/libliquid.a
}
