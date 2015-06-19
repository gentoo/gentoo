# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/shotwell/shotwell-0.21.0.ebuild,v 1.1 2015/02/22 11:37:25 jlec Exp $

EAPI=5

GCONF_DEBUG="no"
VALA_MIN_API_VERSION="0.26"
VALA_MAX_API_VERSION="0.26"

inherit eutils gnome2 multilib toolchain-funcs vala versionator

MY_PV=$(get_version_component_range 1-2)
DESCRIPTION="Open source photo manager for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Shotwell"
SRC_URI="
	mirror://gnome/sources/${PN}/$(get_version_component_range 1-2)/${P}.tar.xz
	http://pkgs.fedoraproject.org/cgit/shotwell.git/plain/shotwell.1
	http://pkgs.fedoraproject.org/cgit/shotwell.git/plain/shotwell-icons.tar.bz2
	"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

CORE_SUPPORTED_LANGUAGES="
	af ar as ast bg bn bn_IN ca cs da de el en_GB eo es et eu fi fr gd gl gu he
	hi hr hu ia id it ja kk km kn ko ky lt lv mk ml mr nb nl nn or pa pl pt
	pt_BR ro ru sk sl sr sv ta te th tr uk vi zh_CN zh_HK zh_TW"

for x in ${CORE_SUPPORTED_LANGUAGES}; do
	IUSE+="linguas_${x} "
done

RDEPEND="
	app-text/gnome-doc-utils
	>=dev-db/sqlite-3.5.9:3
	>=dev-libs/dbus-glib-0.80
	>=dev-libs/glib-2.30.0:2
	>=dev-libs/json-glib-0.7.6
	>=dev-libs/libgee-0.8.5:0.8
	>=dev-libs/libxml2-2.6.32:2
	>=dev-util/desktop-file-utils-0.13
	gnome-base/dconf
	>=media-libs/gexiv2-0.4.90
	media-libs/gst-plugins-base:1.0
	media-libs/gst-plugins-good:1.0
	media-libs/gstreamer:1.0
	media-libs/lcms:2
	>=media-libs/libexif-0.6.16:=
	>=media-libs/libgphoto2-2.4.2:=
	>=media-libs/libraw-0.13.2:=
	>=net-libs/libsoup-2.26.0:2.4
	>=net-libs/rest-0.7:0.7
	>=net-libs/webkit-gtk-1.4:3
	virtual/libgudev:=[introspection]
	>=x11-libs/gtk+-3.12.2:3[X]"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=sys-devel/m4-1.4.13"

DOCS=( AUTHORS MAINTAINERS NEWS README THANKS )

# This probably comes from libraries that
# shotwell-video-thumbnailer links to.
# Nothing we can do at the moment. #435048
QA_FLAGS_IGNORED="/usr/libexec/${PN}/${PN}-video-thumbnailer"

pkg_setup() {
	tc-export CC
	G2CONF="${G2CONF}
		--disable-schemas-compile
		--disable-desktop-update
		--disable-icon-update
		--prefix=/usr
		--lib=$(get_libdir)"
}

src_prepare() {
	vala_src_prepare
	sed \
		-e 's|CFLAGS :|CFLAGS +|g' \
		-i plugins/Makefile.plugin.mk || die
	epatch \
		"${FILESDIR}"/${PN}-0.13.1-ldflags.patch
}

src_configure() {
	./configure \
		${G2CONF} \
		|| die
}

src_compile() {
	local valaver="$(vala_best_api_version)"
	emake VALAC="$(type -p valac-${valaver})"
}

src_install() {
	local res
	gnome2_src_install
	for x in ${LANGS}; do
		if ! has ${x} ${LINGUAS}; then
			find "${D}"/usr/share/locale/${x} -type f -exec rm {} + || die
		fi
	done
	doman "${DISTDIR}"/${PN}.1
	for res in 16 22 24 32 48 256; do
		doicon -s ${res} "${WORKDIR}"/${res}x${res}/*
	done
}
