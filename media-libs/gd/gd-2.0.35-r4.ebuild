# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gd/gd-2.0.35-r4.ebuild,v 1.17 2015/05/12 07:16:38 vapier Exp $

EAPI="5"

inherit autotools eutils flag-o-matic multilib-minimal

DESCRIPTION="A graphics library for fast image creation"
HOMEPAGE="http://libgd.org/ http://www.boutell.com/gd/"
SRC_URI="http://libgd.org/releases/${P}.tar.bz2"

LICENSE="gd IJG HPND BSD"
SLOT="2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="fontconfig jpeg png static-libs truetype xpm zlib"

#fontconfig has prefixed font paths, details see bug #518970
REQUIRED_USE="prefix? ( fontconfig )"

RDEPEND="fontconfig? ( >=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}] )
	jpeg? ( >=virtual/jpeg-0-r2:0=[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}] )
	truetype? ( >=media-libs/freetype-2.5.0.1[${MULTILIB_USEDEP}] )
	xpm? ( >=x11-libs/libXpm-3.5.10-r1[${MULTILIB_USEDEP}] >=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/gdlib-config
)

src_prepare() {
	epatch "${FILESDIR}"/${P}-libpng14.patch #305101
	epatch "${FILESDIR}"/${P}-maxcolors.patch #292130
	epatch "${FILESDIR}"/${P}-fontconfig.patch #363367
	epatch "${FILESDIR}"/${P}-libpng-pkg-config.patch

	# Avoid programs we never install
	local make_sed=( -e '/^noinst_PROGRAMS/s:noinst:check:' )
	use png || make_sed+=( -e '/_PROGRAMS/s:(gdparttopng|gdtopng|gd2topng|pngtogd|pngtogd2|webpng)::g' )
	use zlib || make_sed+=( -e '/_PROGRAMS/s:(gd2topng|gd2copypal|gd2togif|giftogd2|gdparttopng|pngtogd2)::g' )
	sed -i -r "${make_sed[@]}" Makefile.am || die

	# bug 466996
	sed -i 's/AM_PROG_CC_STDC/AC_PROG_CC/' configure.ac || die

	cat <<-EOF > acinclude.m4
	m4_ifndef([AM_ICONV],[m4_define([AM_ICONV],[AC_SUBST(LIBICONV)])])
	EOF

	eautoreconf
}

multilib_src_configure() {
	# setup a default FONT path that has a chance of existing using corefonts,
	# as to make it more useful with e.g. gnuplot
	local fontpath="${EPREFIX}/usr/share/fonts/corefonts"
	# like with fontconfig, try to use fonts from the host OS, because that's
	# beneficial for the user
	use prefix && case ${CHOST} in
		*-darwin*)
			fontpath+=":/Library/Fonts:/System/Library/Fonts"
		;;
		*-solaris*)
			[[ -d /usr/X/lib/X11/fonts/TrueType ]] && \
				fontpath+=":/usr/X/lib/X11/fonts/TrueType"
			[[ -d /usr/X/lib/X11/fonts/Type1 ]] && \
				fontpath+=":/usr/X/lib/X11/fonts/Type1"
			# OpenIndiana
			[[ -d /usr/share/fonts/X11/Type1 ]] && \
				fontpath+=":/usr/share/fonts/X11/Type1"
		;;
		*-linux-gnu)
			[[ -d /usr/share/fonts/truetype ]] && \
				fontpath+=":/usr/share/fonts/truetype"
		;;
	esac
	append-cppflags "-DDEFAULT_FONTPATH=\\\"${fontpath}\\\""

	export ac_cv_lib_z_deflate=$(usex zlib)
	# we aren't actually {en,dis}abling X here ... the configure
	# script uses it just to add explicit -I/-L paths which we
	# don't care about on Gentoo systems.
	ECONF_SOURCE=${S} \
	econf \
		--without-x \
		$(use_enable static-libs static) \
		$(use_with fontconfig) \
		$(use_with png) \
		$(use_with truetype freetype) \
		$(use_with jpeg) \
		$(use_with xpm)
}

multilib_src_install_all() {
	dodoc INSTALL README*
	dohtml -r ./
	prune_libtool_files
}
