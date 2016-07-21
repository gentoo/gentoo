# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
VALA_MIN_API_VERSION="0.28"

inherit gnome2 multilib toolchain-funcs vala versionator

MY_PV=$(get_version_component_range 1-2)
DESCRIPTION="Open source photo manager for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Shotwell"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

CORE_SUPPORTED_LANGUAGES="
	af ar as ast bg bn bn_IN bs ca cs da de el en_GB eo es et eu fi fr gd gl gu
	he hi hr hu ia id it ja kk km kn ko ky lt lv mk ml mr nb nl nn or pa pl pt
	pt_BR ro ru sk sl sr sr@latin sv ta te th tr uk vi zh_CN zh_HK zh_TW"

for x in ${CORE_SUPPORTED_LANGUAGES}; do
	IUSE+="linguas_${x} "
done

RDEPEND="
	app-text/gnome-doc-utils
	>=dev-db/sqlite-3.5.9:3
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
	>=media-libs/libgphoto2-2.5:=
	>=media-libs/libraw-0.13.2:=
	>=net-libs/libsoup-2.26.0:2.4
	>=net-libs/rest-0.7:0.7
	net-libs/webkit-gtk:4
	virtual/libgudev:=[introspection]
	>=x11-libs/gtk+-3.12.2:3[X]
"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=sys-devel/m4-1.4.13
"

# This probably comes from libraries that
# shotwell-video-thumbnailer links to.
# Nothing we can do at the moment. #435048
QA_FLAGS_IGNORED="/usr/libexec/${PN}/${PN}-video-thumbnailer"

src_prepare() {
	local x
	local linguas="en_GB ${LINGUAS}"

	vala_src_prepare

	sed \
		-e 's|CFLAGS :|CFLAGS +|g' \
		-i plugins/Makefile.plugin.mk || die

	# remove disabled lenguages from build
	for x in ${CORE_SUPPORTED_LANGUAGES}; do
		if ! has ${x} ${linguas}; then
			sed -i "/^${x}$/d" "${S}"/po/LINGUAS || die
		fi
	done

	gnome2_src_prepare
}

src_configure() {
	# Not a normal configure
	./configure \
		--disable-schemas-compile \
		--disable-desktop-update \
		--disable-icon-update \
		--prefix=/usr \
		--lib=$(get_libdir) || die
}

src_compile() {
	tc-export CC
	local valaver="$(vala_best_api_version)"

	# Parallel build fixed in next version
	MAKEOPTS="${MAKEOPTS} -j1" gnome2_src_compile VALAC="$(type -p valac-${valaver})"
}
