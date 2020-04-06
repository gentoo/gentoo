# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE_LA_PUNT="yes"

inherit mate readme.gentoo-r1

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="Engrampa archive manager for MATE"
LICENSE="GPL-2"
SLOT="0"

IUSE="caja magic packagekit"

COMMON_DEPEND="
	>=dev-libs/glib-2.50:2
	>=dev-libs/json-glib-0.14
	virtual/libintl
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3[X]
	x11-libs/pango
	caja? ( >=mate-base/caja-1.17.1 )
	magic? ( sys-apps/file )
	packagekit? ( app-admin/packagekit-base )
"

RDEPEND="${COMMON_DEPEND}
	virtual/libintl
	!!app-arch/mate-file-archiver
"

DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8:*
	virtual/pkgconfig
"

src_configure() {
	mate_src_configure \
		--disable-run-in-place \
		$(use_enable caja caja-actions) \
		$(use_enable magic) \
		$(use_enable packagekit)
}

src_install() {
	mate_src_install
}

pkg_postinst() {
	mate_pkg_postinst
	optfeature "Support for 7-zip"  app-arch/p7zip
	optfeature "Support for ace"  app-arch/unace
	optfeature "Support for arj"  app-arch/arj
	optfeature "Support for cpio"  app-arch/cpio
	optfeature "Support for deb"  app-arch/dpkg
	optfeature "Support for iso"  app-cdr/cdrtools
	optfeature "Support for jar,zip"  app-arch/zip app-arch/unzip
	optfeature "Support for lha"  app-arch/lha
	optfeature "Support for lzma"  app-arch/xz-utils
	optfeature "Support for lzop"  app-arch/lzop
	optfeature "Support for rar"  app-arch/unrar
	optfeature "Support for rpm"  app-arch/rpm
	optfeature "Support for unstuff"  app-arch/stuffit
	optfeature "Support for zoo"  app-arch/zoo
}
