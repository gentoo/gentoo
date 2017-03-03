# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic multilib-minimal

MY_P=${P/_}
MY_P=${MY_P/_p/.}

DESCRIPTION="Audio compression format designed for speech"
HOMEPAGE="http://www.speex.org/"
SRC_URI="http://downloads.xiph.org/releases/speex/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="armv5te cpu_flags_x86_sse static-libs utils +vbr"

RDEPEND="
	utils? (
		media-libs/libogg:=
		media-libs/speexdsp
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}/${P}-configure.patch" )

src_prepare() {
	default

	sed -i \
		-e 's:noinst_PROGRAMS:check_PROGRAMS:' \
		libspeex/Makefile.am || die

	eautoreconf
}

multilib_src_configure() {
	append-lfs-flags

	# Can also be configured without floating point
	# --enable-fixed-point
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		$(usex arm $(usex armv5te '--disable-arm4-asm' '--enable-arm4-asm') '--disable-arm4-asm') \
		$(use_enable armv5te arm5e-asm) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable vbr) \
		$(use_with utils speexdsp) \
		$(use_enable utils binaries)
}

multilib_src_install_all() {
	default
	find "${D}" -name '*.la' -delete || die
}
