# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11} )
MATE_LA_PUNT="yes"

inherit mate python-single-r1 linux-info

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Store, Sync and Share Files Online"
LICENSE="CC-BY-ND-3.0 GPL-3+ public-domain"
SLOT="0"

IUSE="debug nls"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	>=app-accessibility/at-spi2-core-2.46.0
	>=dev-libs/glib-2.50:2
	$(python_gen_cond_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
	>=mate-base/caja-1.19.1
	mate-extra/caja-extensions
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/libXinerama
	x11-libs/pango
"

RDEPEND="${COMMON_DEPEND}
	net-misc/dropbox
"

BDEPEND="${COMMON_DEPEND}
	dev-python/docutils
	virtual/pkgconfig
"

CONFIG_CHECK="~INOTIFY_USER"

pkg_setup() {
	python-single-r1_pkg_setup
	check_extra_config
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
		$(use_enable debug) \
		$(use_enable nls)
}

src_install() {
	python_fix_shebang caja-dropbox.in

	mate_src_install
}

pkg_postinst() {
	mate_pkg_postinst

	for v in ${REPLACING_VERSIONS}; do
		if ver_test "${v}" "-lt" "1.24.0-r1" || ver_test "${v}" "-eq" "9999"; then
			ewarn "Starting with ${CATEGORY}/${PN}-1.24.0-r1, ${PN} now no longer"
			ewarn "configures caja-dropbox to use its own group. This brings caja-dropbox in line"
			ewarn "with nautilus-dropbox and dolphin-plugins-dropbox. You may remove the 'dropbox' group."
		fi
	done
}
