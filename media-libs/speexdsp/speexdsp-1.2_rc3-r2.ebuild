# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic multilib-minimal

MY_P=${P/_}
MY_P=${MY_P/_p/.}

DESCRIPTION="Audio compression format designed for speech -- DSP"
HOMEPAGE="https://www.speex.org/"
SRC_URI="https://downloads.xiph.org/releases/speex/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_arm_neon static-libs"

RDEPEND="!<media-libs/speex-1.2.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${P}-configure.patch"
	"${FILESDIR}/${P}-config_types.h.patch"
	"${FILESDIR}/${P}-overflow.patch"
)

src_prepare() {
	default

	sed -i \
		-e 's:noinst_PROGRAMS:check_PROGRAMS:' \
		libspeexdsp/Makefile.am || die

	eautoreconf
}

multilib_src_configure() {
	append-lfs-flags

	# Can also be configured with one of:
	# --enable-fixed-point             (no floating point)
	# --with-fft=proprietary-intel-mkl (mkl)
	# --with-fft=gpl-fftw3             (fftw)
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable cpu_flags_arm_neon neon)
}

multilib_src_install_all() {
	default
	find "${D}" -name '*.la' -delete || die
}
