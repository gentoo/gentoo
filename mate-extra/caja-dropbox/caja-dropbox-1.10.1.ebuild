# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 python-single-r1 linux-info user versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="Store, Sync and Share Files Online"
HOMEPAGE="http://www.dropbox.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="debug"

RDEPEND="
	dev-libs/atk:0
	>=dev-libs/glib-2.14:2
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	>=mate-base/caja-1.10:0
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	net-misc/dropbox:0
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libXinerama:0
	x11-libs/pango:0"

DEPEND="${RDEPEND}
	dev-python/docutils:0
	virtual/pkgconfig:*"

G2CONF="${G2CONF} $(use_enable debug) --disable-static"

CONFIG_CHECK="~INOTIFY_USER"

pkg_setup () {
	python-single-r1_pkg_setup
	check_extra_config
	enewgroup dropbox
}

src_prepare() {
	gnome2_src_prepare

	# Use system dropbox.
	sed -e "s|~/[.]dropbox-dist|/opt/dropbox|" \
		-e 's|\(DROPBOXD_PATH = \).*|\1"/opt/dropbox/dropboxd"|' \
			-i caja-dropbox.in || die

	# Use system rst2man.
	epatch "${FILESDIR}"/${P}-system-rst2man.patch

	AT_NOELIBTOOLIZE=yes eautoreconf
}

DOCS="AUTHORS ChangeLog NEWS README"

src_install () {
	python_fix_shebang caja-dropbox.in

	gnome2_src_install

	local extensiondir="$(pkg-config --variable=extensiondir libcaja-extension)"
	[ -z ${extensiondir} ] && die "pkg-config unable to get caja extensions dir"

	# Strip $EPREFIX from $extensiondir as fowners/fperms act on $ED not $D.
	extensiondir="${extensiondir#${EPREFIX}}"
	use prefix || fowners root:dropbox "${extensiondir}"/libcaja-dropbox.so
	fperms o-rwx "${extensiondir}"/libcaja-dropbox.so
}

pkg_postinst () {
	gnome2_pkg_postinst

	elog
	elog "Add any users who wish to have access to the dropbox caja"
	elog "plugin to the group 'dropbox'. You need to setup a drobox account"
	elog "before using this plugin. Visit ${HOMEPAGE} for more information."
	elog
}
