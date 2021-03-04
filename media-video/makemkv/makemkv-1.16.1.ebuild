# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic linux-info xdg

MY_P=makemkv-oss-${PV}
MY_PB=makemkv-bin-${PV}

DESCRIPTION="Tool for ripping and streaming Blu-ray, HD-DVD and DVD discs"
HOMEPAGE="http://www.makemkv.com/"
SRC_URI="http://www.makemkv.com/download/${MY_P}.tar.gz
	http://www.makemkv.com/download/${MY_PB}.tar.gz"

LICENSE="LGPL-2.1 MPL-1.1 MakeMKV-EULA openssl"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+gui libressl"
RESTRICT="bindist mirror"

QA_PREBUILT="usr/bin/makemkvcon usr/bin/mmdtsdec"

DEPEND="
	sys-libs/glibc
	dev-libs/expat
	sys-libs/zlib
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	>=media-video/ffmpeg-1.0.0:0=
	!libressl? ( dev-libs/openssl:0=[-bindist(-)] )
	libressl? ( dev-libs/libressl:0= )
"
RDEPEND="
	${DEPEND}
	media-video/ccextractor
	net-misc/wget
"
BDEPEND="
	virtual/pkgconfig
	gui? ( dev-qt/qtcore:5 )
"

CONFIG_CHECK="~CHR_DEV_SG"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-path.patch
)

src_configure() {
	# See bug #439380.
	replace-flags -O* -Os

	econf \
		--enable-debug \
		--disable-noec \
		$(use_enable gui) \
		$(use_enable gui qt5)
}

src_install() {
	default

	# add missing symlinks for QA
	dosym libdriveio.so.0 /usr/$(get_libdir)/libdriveio.so.0.${PV}
	dosym libdriveio.so.0 /usr/$(get_libdir)/libdriveio.so
	dosym libmakemkv.so.1 /usr/$(get_libdir)/libmakemkv.so.1.${PV}
	dosym libmakemkv.so.1 /usr/$(get_libdir)/libmakemkv.so
	dosym libmmbd.so.0    /usr/$(get_libdir)/libmmbd.so
	dosym libmmbd.so.0    /usr/$(get_libdir)/libmmbd.so.0.${PV}

	cd "${WORKDIR}"/${MY_PB} || die

	# install prebuilt bin
	dobin bin/$(usex x86 i386 ${ARCH})/makemkvcon

	# additional tool is actually part of makemkvcon
	dosym makemkvcon /usr/bin/sdftool

	# install profiles and locales
	insinto /usr/share/MakeMKV
	doins src/share/*

	# add symlink rather than relying on MMCCEXTRACTOR env var
	dosym ccextractor /usr/bin/mmccextr
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "While MakeMKV is in beta mode, upstream has provided a license"
	elog "to use if you do not want to purchase one."
	elog ""
	elog "See this forum thread for more information, including the key:"
	elog "https://www.makemkv.com/forum/viewtopic.php?f=5&t=1053"
	elog ""
	elog "Note that beta license may have an expiration date and you will"
	elog "need to check for newer licenses/releases. "
	elog ""
	elog "We previously said to copy default.mmcp.xml to ~/.MakeMKV/. This"
	elog "is no longer necessary and you should delete it from there to"
	elog "avoid warning messages."
	elog ""
	elog "MakeMKV can also act as a drop-in replacement for libaacs and"
	elog "libbdplus, allowing transparent decryption of a wider range of"
	elog "titles under players like VLC and mplayer. To enable this, set"
	elog "the following variables when launching the player:"
	elog "LIBAACS_PATH=libmmbd LIBBDPLUS_PATH=libmmbd"
}
