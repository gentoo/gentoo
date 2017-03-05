# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils python-r1 linux-info gnome2 readme.gentoo user

DESCRIPTION="Store, Sync and Share Files Online"
HOMEPAGE="http://www.dropbox.com/"
SRC_URI="http://www.dropbox.com/download?dl=packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	gnome-base/nautilus
	dev-libs/glib:2
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	net-misc/dropbox
	x11-libs/gtk+:2
	x11-libs/libnotify
	x11-libs/libXinerama"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-python/docutils[${PYTHON_USEDEP}]"

CONFIG_CHECK="~INOTIFY_USER"

pkg_setup () {
	check_extra_config
	enewgroup dropbox

	DOC_CONTENTS="Add any users who wish to have access to the dropbox nautilus
		plugin to the group 'dropbox'. You need to setup a drobox account
		before using this plugin. Visit ${HOMEPAGE} for more information."

	python_export_best
}

src_prepare() {
	G2CONF="${G2CONF} $(use_enable debug) --disable-static"

	gnome2_src_prepare

	# use sysem dropbox
	sed \
		-e "s|~/[.]dropbox-dist|${EPREFIX}/opt/dropbox|" \
		-e "s|\(DROPBOXD_PATH = \).*|\1\"${EPREFIX}/opt/dropbox/dropboxd\"|" \
		-i dropbox.in || die
	# us system rst2man
	epatch "${FILESDIR}"/${PN}-0.7.0-system-rst2man.patch
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.in || die
	AT_NOELIBTOOLIZE=yes eautoreconf
}

src_install () {
	gnome2_src_install

	local extensiondir="$(pkg-config --variable=extensiondir libnautilus-extension)"
	[ -z ${extensiondir} ] && die "pkg-config unable to get nautilus extensions dir"

	# Strip $EPREFIX from $extensiondir as fowners/fperms act on $ED not $D
	extensiondir="${extensiondir#${EPREFIX}}"

	use prefix || fowners root:dropbox "${extensiondir}"/libnautilus-dropbox.so
	fperms o-rwx "${extensiondir}"/libnautilus-dropbox.so

	readme.gentoo_create_doc

	python_replicate_script "${ED}"/usr/bin/dropbox
}

pkg_postinst () {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}
