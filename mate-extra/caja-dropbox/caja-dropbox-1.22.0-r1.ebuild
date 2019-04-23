# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6,7} )
MATE_LA_PUNT="yes"

inherit mate python-single-r1 linux-info user

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Store, Sync and Share Files Online"
LICENSE="GPL-2"
SLOT="0"

IUSE="debug"

COMMON_DEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.50:2
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=mate-base/caja-1.19.1
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/libXinerama
	x11-libs/pango"

RDEPEND="${COMMON_DEPEND}
	net-misc/dropbox"

DEPEND="${COMMON_DEPEND}
	dev-python/docutils
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

	sed -e 's|\[rst2man\]|\[rst2man\.py\]|' -i configure.ac || die

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
	elog "plugin to the group 'dropbox'. You need to setup a Dropbox account"
	elog "before using this plugin. Visit ${HOMEPAGE} for more information."
	elog
}
