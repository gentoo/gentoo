# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils multilib

DESCRIPTION="A library to play a wide range of module formats"
HOMEPAGE="http://mikmod.shlomifish.org/"
SRC_URI="http://mikmod.shlomifish.org/files/${P}.tar.gz"

LICENSE="LGPL-2+ LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="+alsa coreaudio oss static-libs"

REQUIRED_USE="|| ( alsa oss coreaudio )"

RDEPEND="alsa? ( media-libs/alsa-lib )
	!${CATEGORY}/${PN}:2"
DEPEND="${RDEPEND}
	oss? ( virtual/os-headers )"

DOCS="AUTHORS NEWS README TODO"

src_prepare() {
	EPATCH_SOURCE="${FILESDIR}"/${PVR} EPATCH_SUFFIX=patch epatch
	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.in || die #468212
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable alsa) \
		--disable-nas \
		$(use_enable coreaudio osx) \
		$(use_enable oss) \
		$(use_enable static-libs static)
}

src_install() {
	default
	dohtml docs/*.html

	prune_libtool_files
	dosym ${PN}$(get_libname 3) /usr/$(get_libdir)/${PN}$(get_libname 2)

	cat <<-EOF > "${T}"/${PN}.pc
	prefix=/usr
	exec_prefix=\${prefix}
	libdir=/usr/$(get_libdir)
	includedir=\${prefix}/include
	Name: ${PN}
	Description: ${DESCRIPTION}
	Version: ${PV}
	Libs: -L\${libdir} -lmikmod
	Libs.private: -ldl -lm
	Cflags: -I\${includedir} $("${ED}"/usr/bin/libmikmod-config --cflags)
	EOF

	insinto /usr/$(get_libdir)/pkgconfig
	doins "${T}"/${PN}.pc
}
