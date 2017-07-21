# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="Engrampa archive manager for MATE"
LICENSE="GPL-2"
SLOT="0"

IUSE="caja magic packagekit"

COMMON_DEPEND="
	>=dev-libs/glib-2.32.0:2
	>=dev-libs/json-glib-0.14:0
	x11-libs/gdk-pixbuf:2
	x11-libs/pango:0
	virtual/libintl:0
	caja? ( >=mate-base/caja-1.1.0 )
	>=x11-libs/gtk+-3.14:3[X]
	magic? ( sys-apps/file )
	packagekit? ( app-admin/packagekit-base )
	!!app-arch/mate-file-archiver"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	>=dev-util/intltool-0.50.1:*
	sys-devel/gettext:*
	virtual/pkgconfig:*"

src_configure() {
	mate_src_configure \
		--disable-run-in-place \
		--disable-deprecations \
		$(use_enable caja caja-actions) \
		$(use_enable magic) \
		$(use_enable packagekit)
}

pkg_postinst() {
	mate_pkg_postinst

	elog ""
	elog "${PN} is a frontend for several archiving utilities. If you want a"
	elog "particular achive format supported install the relevant package."
	elog
	elog "For example:"
	elog "  7-zip   : emerge app-arch/p7zip"
	elog "  ace     : emerge app-arch/unace"
	elog "  arj     : emerge app-arch/arj"
	elog "  cpio    : emerge app-arch/cpio"
	elog "  deb     : emerge app-arch/dpkg"
	elog "  iso     : emerge app-cdr/cdrtools"
	elog "  jar,zip : emerge app-arch/zip  or  emerge app-arch/unzip"
	elog "  lha     : emerge app-arch/lha"
	elog "  lzma    : emerge app-arch/xz-utils"
	elog "  lzop    : emerge app-arch/lzop"
	elog "  rar     : emerge app-arch/unrar"
	elog "  rpm     : emerge app-arch/rpm"
	elog "  unstuff : emerge app-arch/stuffit"
	elog "  zoo     : emerge app-arch/zoo"
}
