# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mkvtoolnix/mkvtoolnix-6.6.0.ebuild,v 1.4 2014/08/27 12:29:00 ago Exp $

EAPI=5
inherit eutils multilib toolchain-funcs versionator wxwidgets multiprocessing autotools

DESCRIPTION="Tools to create, alter, and inspect Matroska files"
HOMEPAGE="http://www.bunkus.org/videotools/mkvtoolnix"
SRC_URI="http://www.bunkus.org/videotools/mkvtoolnix/sources/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug pch qt4 wxwidgets"

RDEPEND="
	>=dev-libs/libebml-1.3.0:=
	>=media-libs/libmatroska-1.4.1:=
	>=dev-libs/boost-1.46.0:=
	dev-libs/pugixml
	media-libs/flac
	media-libs/libogg
	media-libs/libvorbis
	sys-apps/file
	>=sys-devel/gcc-4.6
	sys-libs/zlib
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	wxwidgets? ( x11-libs/wxGTK:2.8[X] )
"
DEPEND="${RDEPEND}
	dev-lang/ruby
	virtual/pkgconfig
"

pkg_pretend() {
	# http://bugs.gentoo.org/419257
	local ver=4.6
	local msg="You need at least GCC ${ver}.x for C++11 range-based 'for' and nullptr support."
	if ! version_is_at_least ${ver} $(gcc-version); then
		eerror ${msg}
		die ${msg}
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.8.0-system-pugixml.patch \
		"${FILESDIR}"/${PN}-5.8.0-boost-configure.patch
	eautoreconf
}

src_configure() {
	local myconf

	if use wxwidgets ; then
		WX_GTK_VER="2.8"
		need-wxwidgets unicode
		myconf="--with-wx-config=${WX_CONFIG}"
	fi

	econf \
		$(use_enable debug) \
		$(use_enable qt4 qt) \
		$(use_enable wxwidgets) \
		$(usex pch "" --disable-precompiled-headers) \
		${myconf} \
		--disable-optimization \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--with-boost="${EPREFIX}"/usr \
		--with-boost-libdir="${EPREFIX}"/usr/$(get_libdir) \
		--without-curl
}

src_compile() {
	./drake V=1 -j$(makeopts_jobs) || die
}

src_install() {
	DESTDIR="${D}" ./drake -j$(makeopts_jobs) install || die

	dodoc AUTHORS ChangeLog README TODO
	doman doc/man/*.1

	use wxwidgets && docompress -x /usr/share/doc/${PF}/guide
}
