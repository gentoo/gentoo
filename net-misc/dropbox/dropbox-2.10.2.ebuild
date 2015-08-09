# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils gnome2-utils pax-utils systemd

DESCRIPTION="Dropbox daemon (pretends to be GUI-less)"
HOMEPAGE="http://dropbox.com/"
SRC_URI="
	x86? ( http://dl-web.dropbox.com/u/17/dropbox-lnx.x86-${PV}.tar.gz )
	amd64? ( http://dl-web.dropbox.com/u/17/dropbox-lnx.x86_64-${PV}.tar.gz )"

LICENSE="CC-BY-ND-3.0 FTL MIT LGPL-2 openssl dropbox"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-linux"
IUSE="+librsync-bundled X"
RESTRICT="mirror strip"

QA_PREBUILT="opt/.*"
QA_EXECSTACK="opt/dropbox/dropbox"

DEPEND="librsync-bundled? ( dev-util/patchelf )"

# Be sure to have GLIBCXX_3.4.9, #393125
# USE=X require wxGTK's dependencies. system-library cannot be used due to
# missing symbol (CtlColorEvent). #443686
RDEPEND="
	X? (
		dev-libs/glib:2
		media-libs/libpng:1.2
		sys-libs/zlib
		virtual/jpeg
		x11-libs/gtk+:2
		x11-libs/libSM
		x11-libs/libXinerama
		x11-libs/libXxf86vm
		x11-libs/pango[X]
		x11-themes/hicolor-icon-theme
	)
	app-arch/bzip2
	dev-libs/popt
	!librsync-bundled? ( net-libs/librsync )
	net-misc/wget
	>=sys-devel/gcc-4.2.0
	sys-libs/zlib
"

src_unpack() {
	unpack ${A}
	mkdir -p "${S}"
	mv "${WORKDIR}"/.dropbox-dist/* "${S}" || die
	mv "${S}"/dropbox-lnx.*-${PV}/* "${S}" || die
	rmdir .dropbox-dist
}

src_prepare() {
	rm -vf libbz2* libpopt.so.0 libpng12.so.0 || die
	if use X ; then
		mv images/hicolor/16x16/status "${T}" || die
	else
		rm -vrf *wx* images || die
	fi
	if use librsync-bundled ; then
		patchelf --set-rpath '$ORIGIN' _librsync.so || die
	else
		rm -vf librsync.so.1 || die
	fi
	mv cffi-0.7.2-py2.7-*.egg dropbox_sqlite_ext-0.0-py2.7.egg distribute-0.6.26-py2.7.egg "${T}" || die
	rm -rf *.egg library.zip || die
	mv "${T}"/cffi-0.7.2-py2.7-*.egg "${T}"/dropbox_sqlite_ext-0.0-py2.7.egg "${T}"/distribute-0.6.26-py2.7.egg "${S}" || die
	ln -s dropbox library.zip || die
	pax-mark cm dropbox
	mv README ACKNOWLEDGEMENTS "${T}" || die
}

src_install() {
	local targetdir="/opt/dropbox"

	insinto "${targetdir}"
	doins -r *
	fperms a+x "${targetdir}"/{dropbox,dropboxd}
	dosym "${targetdir}/dropboxd" "/opt/bin/dropbox"

	use X && doicon -s 16 -c status "${T}"/status

	newinitd "${FILESDIR}"/dropbox.initd dropbox
	newconfd "${FILESDIR}"/dropbox.conf dropbox
	systemd_newunit "${FILESDIR}"/dropbox_at.service "dropbox@.service"

	dodoc "${T}"/{README,ACKNOWLEDGEMENTS}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
