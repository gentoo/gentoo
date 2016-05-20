# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils multilib flag-o-matic

MY_P=makemkv-oss-${PV}
MY_PB=makemkv-bin-${PV}

DESCRIPTION="Tool for ripping and streaming Blu-ray, HD-DVD and DVD discs"
HOMEPAGE="http://www.makemkv.com/"
SRC_URI="http://www.makemkv.com/download/${MY_P}.tar.gz
	http://www.makemkv.com/download/${MY_PB}.tar.gz"

LICENSE="LGPL-2.1 MPL-1.1 MakeMKV-EULA openssl"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libav multilib qt4 qt5"
REQUIRED_USE="?? ( qt4 qt5 )"

QA_PREBUILT="usr/bin/makemkvcon usr/bin/mmdtsdec"

DEPEND="
	sys-libs/glibc[multilib?]
	dev-libs/expat
	dev-libs/openssl:0
	sys-libs/zlib
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	!libav? ( >=media-video/ffmpeg-1.0.0:0= )
	libav? ( >=media-video/libav-0.8.9:0= )
"
RDEPEND="${DEPEND}
	net-misc/wget"

# Upstream uses non-standard locale names so map them with this
# associative array and perform some tricks below.
declare -A MY_LOCALES
MY_LOCALES=(
	[zh]=chi
	[da]=dan
	[de]=deu
	[nl]=dut
	[fr]=fra
	[it]=ita
	[ja]=jpn
	[no]=nor
	[fa]=per
	[pl]=pol
	[pt_BR]=ptb
	[es]=spa
	[sv]=swe
)

PLOCALES="${!MY_LOCALES[@]}"
inherit l10n

S="${WORKDIR}/makemkv-oss-${PV}"

src_prepare() {
	PATCHES+=( "${FILESDIR}"/${PN}-{makefile,path,sysmacros}.patch )

	# Qt5 always trumps Qt4 if it is available. There are no configure
	# options or variables to control this and there is no publicly
	# available configure.ac either.
	if use qt4; then
		PATCHES+=( "${FILESDIR}"/${PN}-qt4.patch )
	elif use qt5; then
		PATCHES+=( "${FILESDIR}"/${PN}-qt5.patch )
	fi

	# Check for locale changes against the non-standard names.
	PLOCALES="${MY_LOCALES[@]}" l10n_find_plocales_changes "${WORKDIR}"/${MY_PB}/src/share makemkv_ .mo.gz

	default
}

src_configure() {
	# See bug #439380.
	replace-flags -O* -Os

	local econf_args=()

	if use qt4 || use qt5; then
		econf_args+=( '--enable-gui' )
	else
		econf_args+=( '--disable-gui' )
	fi

	econf "${econf_args[@]}"
}

src_compile() {
	emake GCC="$(tc-getCC) ${CFLAGS} ${LDFLAGS}"
}

src_install() {
	# install oss package
	dolib.so out/libdriveio.so.0
	dolib.so out/libmakemkv.so.1
	dolib.so out/libmmbd.so.0
	dosym libdriveio.so.0 /usr/$(get_libdir)/libdriveio.so.0.${PV}
	dosym libdriveio.so.0 /usr/$(get_libdir)/libdriveio.so
	dosym libmakemkv.so.1 /usr/$(get_libdir)/libmakemkv.so.1.${PV}
	dosym libmakemkv.so.1 /usr/$(get_libdir)/libmakemkv.so
	dosym libmmbd.so.0    /usr/$(get_libdir)/libmmbd.so
	dosym libmmbd.so.0    /usr/$(get_libdir)/libmmbd.so.0.${PV}

	if use qt4 || use qt5; then
		dobin out/makemkv

		local res
		for res in 16 22 32 64 128; do
			newicon -s ${res} makemkvgui/share/icons/${res}x${res}/makemkv.png ${PN}.png
		done

		make_desktop_entry ${PN} MakeMKV ${PN} 'Qt;AudioVideo;Video'
	fi

	cd "${WORKDIR}"/${MY_PB} || die

	# install prebuilt bins
	if use x86; then
		dobin bin/i386/{makemkvcon,mmdtsdec}
	elif use amd64; then
		dobin bin/amd64/makemkvcon
		use multilib && dobin bin/i386/mmdtsdec
	fi

	insinto /usr/share/MakeMKV

	# install profiles
	doins src/share/*.xml

	# install locales
	local locale
	for locale in $(l10n_get_locales); do
		doins src/share/makemkv_${MY_LOCALES[${locale}]}.mo.gz
	done
}

pkg_preinst() { gnome2_icon_savelist; }

pkg_postinst() {
	gnome2_icon_cache_update

	elog "While MakeMKV is in beta mode, upstream has provided a license"
	elog "to use if you do not want to purchase one."
	elog ""
	elog "See this forum thread for more information, including the key:"
	elog "http://www.makemkv.com/forum2/viewtopic.php?f=5&t=1053"
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

pkg_postrm() { gnome2_icon_cache_update; }
