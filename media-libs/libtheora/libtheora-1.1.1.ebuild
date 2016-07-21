# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils flag-o-matic

DESCRIPTION="The Theora Video Compression Codec"
HOMEPAGE="http://www.theora.org"
SRC_URI="http://downloads.xiph.org/releases/theora/${P/_}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~ppc-aix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="doc +encode examples static-libs"

RDEPEND="media-libs/libogg:=
	encode? ( media-libs/libvorbis:= )
	examples? (
		media-libs/libpng:0=
		>=media-libs/libsdl-0.11.0
		media-libs/libvorbis:=
		)"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"
REQUIRED_USE="examples? ( encode )" #285895

S=${WORKDIR}/${P/_}

VARTEXFONTS=${T}/fonts

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.0_beta2-flags.patch \
		"${FILESDIR}"/${P}-libpng16.patch #465450

	# bug 467006
	sed -i "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" configure.ac || die

	AT_M4DIR=m4 eautoreconf
}

src_configure() {
	use x86 && filter-flags -fforce-addr -frename-registers #200549
	use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	# --disable-spec because LaTeX documentation has been prebuilt
	econf \
		$(use_enable static-libs static) \
		--disable-spec \
		$(use_enable encode) \
		$(use_enable examples)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir="${EPREFIX}"/usr/share/doc/${PF} \
		install

	dodoc AUTHORS CHANGES README

	if use examples; then
		if use doc; then
			insinto /usr/share/doc/${PF}/examples
			doins examples/*.[ch]
		fi

		dobin examples/.libs/png2theora
		for bin in dump_{psnr,video} {encoder,player}_example; do
			newbin examples/.libs/${bin} theora_${bin}
		done
	fi

	prune_libtool_files
}
