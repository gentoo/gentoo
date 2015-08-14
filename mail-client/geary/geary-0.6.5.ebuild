# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VALA_MIN_API_VERSION=0.22

inherit eutils fdo-mime gnome2-utils vala cmake-utils

MY_P=${P/_pre/pr}
DESCRIPTION="A lightweight, easy-to-use, feature-rich email client"
HOMEPAGE="http://www.yorba.org/projects/geary/"
SRC_URI="mirror://gnome/sources/geary/${PV:0:3}/${MY_P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND="
	app-crypt/gcr[gtk,introspection,vala]
	app-crypt/libsecret
	dev-db/sqlite:3
	dev-libs/glib:2
	>=dev-libs/libgee-0.8.5:0.8
	dev-libs/libxml2:2
	dev-libs/gmime:2.6
	media-libs/libcanberra
	>=net-libs/webkit-gtk-1.10.0:3[introspection]
	>=x11-libs/gtk+-3.6.0:3[introspection]
	x11-libs/libnotify"
RDEPEND="${DEPEND}
	gnome-base/gsettings-desktop-schemas
	nls? ( virtual/libintl )"
DEPEND="${DEPEND}
	app-text/gnome-doc-utils
	dev-util/desktop-file-utils
	nls? ( sys-devel/gettext )
	$(vala_depend)
	virtual/pkgconfig"

DOCS=( AUTHORS MAINTAINERS README NEWS THANKS )

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.5.3-{unity,vapigen}.patch \
		"${FILESDIR}"/${PN}-0.6.3-cflags.patch \
		"${FILESDIR}"/${PN}-0.6.0-desktopfile.patch

	local i
	if use nls ; then
		if [[ -n "${LINGUAS+x}" ]] ; then
			for i in $(cd po ; echo *.po) ; do
				if ! has ${i%.po} ${LINGUAS} ; then
					sed -i -e "/^${i%.po}$/d" po/LINGUAS || die
				fi
			done
		fi
	else
		sed -i -e 's#add_subdirectory(po)##' CMakeLists.txt || die
	fi

	cmake-utils_src_prepare
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDESKTOP_UPDATE=OFF
		-DGSETTINGS_COMPILE=OFF
		-DICON_UPDATE=OFF
		-DVALA_EXECUTABLE="${VALAC}"
		-DWITH_UNITY=OFF
		-DDESKTOP_VALIDATE=OFF
	)

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	elog "For libnotify sounds you will need"
	elog "\"alsa\" or \"pulseaudio\" useflag of media-libs/libcanberra"
	elog "enabled."

	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
}
