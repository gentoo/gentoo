# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils multilib pax-utils versionator

DESCRIPTION="Video softphone based on the SIP protocol"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="mirror://nongnu/${PN}/$(get_version_component_range 1-2).x/sources/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
# TODO: run-time test for ipv6: does it need mediastreamer[ipv6]?
IUSE="doc gsm-nonstandard gtk ipv6 ncurses nls ssl video"

RDEPEND="
	=media-libs/mediastreamer-2.8*[video?,ipv6?]
	>=net-libs/libeXosip-3.0.2
	>=net-libs/libosip-3.0.0
	<net-libs/libosip-4
	<net-libs/libeXosip-4
	>=net-libs/libsoup-2.26
	>=net-libs/ortp-0.20.0
	<net-libs/ortp-0.22.0
	gtk? (
		dev-libs/glib:2
		>=gnome-base/libglade-2.4.0:2.0
		>=x11-libs/gtk+-2.4.0:2
		x11-libs/libnotify
	)
	gsm-nonstandard? ( =media-libs/mediastreamer-2.8*[gsm] )
	ncurses? (
		sys-libs/readline:=
		sys-libs/ncurses
	)
	ssl? ( dev-libs/openssl:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-text/sgmltools-lite )
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
"

IUSE_LINGUAS=" fr it de ja es pl cs nl sv pt_BR hu ru zh_CN"
IUSE="${IUSE}${IUSE_LINGUAS// / linguas_}"

pkg_setup() {
	if ! use gtk && ! use ncurses ; then
		ewarn "gtk and ncurses are disabled."
		ewarn "At least one of these use flags are needed to get a front-end."
		ewarn "Only liblinphone is going to be installed."
	fi

	strip-linguas ${IUSE_LINGUAS}
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-nls.patch \
		"${FILESDIR}"/${P}-automake-1.13.patch
	# remove speex check, avoid bug when mediastreamer[-speex]
	sed -i -e '/SPEEX/d' configure.ac || die "patching configure.ac failed"

	# variable causes "command not found" warning and is not
	# needed anyway
	sed -i -e 's/$(ACLOCAL_MACOS_FLAGS)//' Makefile.am || die

	# fix path to use lib64
	sed -i -e "s:lib\(/liblinphone\):$(get_libdir)\1:" configure.ac \
		|| die "patching configure.ac failed"

	# removing bundled libs dir prevent them to be reconf
	rm -rf mediastreamer2 oRTP || die "should not die"
	sed -i -e "s:oRTP::;s:mediastreamer2::" Makefile.am \
		|| die "patching Makefile.am failed"

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		# we don't want -Werror
		--disable-strict
		# don't bundle libs
		--enable-external-ortp
		--enable-external-mediastreamer
		# seems not used, TODO: ask in ml
		--disable-truespeech
		--disable-zrtp
		$(use_enable doc manual)
		$(use_enable gsm-nonstandard nonstandard-gsm)
		$(use_enable gtk gtk_ui)
		$(use_enable ipv6)
		$(use_enable ncurses console_ui)
		$(use_enable nls)
		$(use_enable video)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" pkgdocdir="/usr/share/doc/${PF}" install # 415161
	dodoc AUTHORS BUGS ChangeLog NEWS README README.arm TODO
	pax-mark m "${ED}usr/bin/linphone"
}
