# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
MATE_LA_PUNT="yes"

inherit mate python-single-r1 linux-info user

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Store, Sync and Share Files Online"
LICENSE="GPL-2"
SLOT="0"

IUSE="debug"

COMMON_DEPEND="
	dev-libs/atk:0
	>=dev-libs/glib-2.36:2
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	>=mate-base/caja-1.17.1
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libXinerama:0
	x11-libs/pango:0"

RDEPEND="${COMMON_DEPEND}
	net-misc/dropbox:0"

DEPEND="${COMMON_DEPEND}
	dev-python/docutils:0
	virtual/pkgconfig:*"

CONFIG_CHECK="~INOTIFY_USER"

pkg_setup () {
	python-single-r1_pkg_setup
	check_extra_config
	enewgroup dropbox
}

MATE_FORCE_AUTORECONF=true

src_prepare() {
	# Use system dropbox.
	sed -e "s|~/[.]dropbox-dist|/opt/dropbox|" \
		-e 's|\(DROPBOXD_PATH = \).*|\1"/opt/dropbox/dropboxd"|' \
			-i caja-dropbox.in || die

	# Use system rst2man.
	epatch "${FILESDIR}"/${PN}-1.8.0-system-rst2man.patch

	mate_src_prepare
}

src_configure() {
	mate_src_configure \
		--disable-static \
		$(use_enable debug)
}

src_install () {
	python_fix_shebang caja-dropbox.in

	mate_src_install

	local extensiondir="$(pkg-config --variable=extensiondir libcaja-extension)"
	[ -z ${extensiondir} ] && die "pkg-config unable to get caja extensions dir"

	# Strip $EPREFIX from $extensiondir as fowners/fperms act on $ED not $D.
	extensiondir="${extensiondir#${EPREFIX}}"
	use prefix || fowners root:dropbox "${extensiondir}"/libcaja-dropbox.so
	fperms o-rwx "${extensiondir}"/libcaja-dropbox.so
}

pkg_postinst () {
	mate_pkg_postinst

	elog
	elog "Add any users who wish to have access to the dropbox caja"
	elog "plugin to the group 'dropbox'. You need to setup a drobox account"
	elog "before using this plugin. Visit ${HOMEPAGE} for more information."
	elog
}
