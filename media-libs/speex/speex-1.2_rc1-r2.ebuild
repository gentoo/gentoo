# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils flag-o-matic multilib-minimal

MY_P=${P/_} ; MY_P=${MY_P/_p/.}

DESCRIPTION="Audio compression format designed for speech"
HOMEPAGE="http://www.speex.org/"
SRC_URI="http://downloads.xiph.org/releases/speex/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="ogg cpu_flags_x86_sse static-libs"

RDEPEND="ogg? ( media-libs/libogg:= )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r3
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS ChangeLog NEWS README README.TI-DSP README.blackfin README.symbian TODO )

src_prepare() {
	epatch "${FILESDIR}"/${P}-r1-configure.patch

	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die #467012

	sed -i \
		-e 's:noinst_PROGRAMS:check_PROGRAMS:' \
		libspeex/Makefile.am || die

	eautoreconf
}

multilib_src_configure() {
	append-lfs-flags

	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_sse sse) \
		$( [ "${ABI}" = "${DEFAULT_ABI}" ] && echo $(use_enable ogg))
	# ogg is only for speexdec/speexenc binaries, useless for non native ABIs
}

multilib_src_install() {
	emake DESTDIR="${D}" docdir="${EPREFIX}/usr/share/doc/${PF}" install

	prune_libtool_files
}
