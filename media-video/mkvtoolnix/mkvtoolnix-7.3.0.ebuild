# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mkvtoolnix/mkvtoolnix-7.3.0.ebuild,v 1.1 2014/10/23 01:48:14 radhermit Exp $

EAPI=5
WX_GTK_VER="3.0"
inherit eutils multilib toolchain-funcs versionator wxwidgets multiprocessing autotools

DESCRIPTION="Tools to create, alter, and inspect Matroska files"
HOMEPAGE="http://www.bunkus.org/videotools/mkvtoolnix"
SRC_URI="http://www.bunkus.org/videotools/mkvtoolnix/sources/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug pch qt5 wxwidgets"

ruby_atom() {
	local ruby_slot=${1/ruby/}
	ruby_slot="${ruby_slot:0:1}.${ruby_slot:1:2}"
	echo "dev-lang/ruby:${ruby_slot}"
}

# hacks to avoid using the ruby eclasses since this requires something similar
# to the python-any-r1 eclass for ruby which currently doesn't exist
RUBY_IMPLS=( ruby19 ruby20 ruby21 )
RUBY_BDEPS="$(for ruby_impl in "${RUBY_IMPLS[@]}"; do echo $(ruby_atom ${ruby_impl}); done)"

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
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
	)
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
"
DEPEND="${RDEPEND}
	|| ( ${RUBY_BDEPS} )
	sys-devel/gettext
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
	local ruby_impl
	for ruby_impl in "${RUBY_IMPLS[@]}"; do
		if has_version "$(ruby_atom ${ruby_impl})"; then
			export RUBY=${ruby_impl}
			break
		fi
	done

	[[ -z ${RUBY} ]] && die "No available ruby implementations to build with"

	epatch "${FILESDIR}"/${PN}-5.8.0-system-pugixml.patch \
		"${FILESDIR}"/${PN}-5.8.0-boost-configure.patch
	eautoreconf
}

src_configure() {
	local myconf

	if use wxwidgets ; then
		need-wxwidgets unicode
		myconf="--with-wx-config=${WX_CONFIG}"
	fi

	econf \
		$(use_enable debug) \
		$(use_enable qt5 qt) \
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
	"${RUBY}" ./drake V=1 -j$(makeopts_jobs) || die
}

src_install() {
	DESTDIR="${D}" "${RUBY}" ./drake -j$(makeopts_jobs) install || die

	dodoc AUTHORS ChangeLog README.md TODO
	doman doc/man/*.1

	use wxwidgets && docompress -x /usr/share/doc/${PF}/guide
}
