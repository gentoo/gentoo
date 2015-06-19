# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libtheora/libtheora-1.1.1-r1.ebuild,v 1.13 2014/08/22 18:16:06 ago Exp $

EAPI=5
inherit autotools eutils flag-o-matic multilib-minimal

DESCRIPTION="The Theora Video Compression Codec"
HOMEPAGE="http://www.theora.org"
SRC_URI="http://downloads.xiph.org/releases/theora/${P/_}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="doc +encode examples static-libs"

RDEPEND=">=media-libs/libogg-1.3.0:=[${MULTILIB_USEDEP}]
	encode? ( >=media-libs/libvorbis-1.3.3-r1:=[${MULTILIB_USEDEP}] )
	examples? (
		media-libs/libpng:0=
		>=media-libs/libsdl-0.11.0
		media-libs/libvorbis:=
		)
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r1
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"
REQUIRED_USE="examples? ( encode )" #285895

S=${WORKDIR}/${P/_}

VARTEXFONTS=${T}/fonts

DOCS=( AUTHORS CHANGES README )

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.0_beta2-flags.patch \
		"${FILESDIR}"/${P}-underlinking.patch \
		"${FILESDIR}"/${P}-libpng16.patch #465450

	# bug 467006
	sed -i "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" configure.ac || die

	AT_M4DIR=m4 eautoreconf
}

multilib_src_configure() {
	use x86 && filter-flags -fforce-addr -frename-registers #200549
	use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	local myconf
	if [ "${ABI}" = "${DEFAULT_ABI}" ] ; then
		myconf=" $(use_enable examples)"
	else
		# those will be overwritten anyway
		myconf=" --disable-examples"
	fi

	# --disable-spec because LaTeX documentation has been prebuilt
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		--disable-spec \
		$(use_enable encode) \
		${myconf}
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		docdir="${EPREFIX}"/usr/share/doc/${PF} \
		install

	if use examples && [ "${ABI}" = "${DEFAULT_ABI}" ]; then
		dobin examples/.libs/png2theora
		for bin in dump_{psnr,video} {encoder,player}_example; do
			newbin examples/.libs/${bin} theora_${bin}
		done
	fi
}

multilib_src_install_all() {
	prune_libtool_files
	einstalldocs

	if use examples && use doc; then
		docinto examples
		dodoc examples/*.[ch]
		docompress -x /usr/share/doc/${PF}/examples
		docinto .
	fi
}
