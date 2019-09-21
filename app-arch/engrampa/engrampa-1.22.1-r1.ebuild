# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE_LA_PUNT="yes"

inherit mate readme.gentoo-r1

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="Engrampa archive manager for MATE"
LICENSE="GPL-2"
SLOT="0"

IUSE="caja magic packagekit"

RDEPEND="
	>=dev-libs/glib-2.50:2
	>=dev-libs/json-glib-0.14
	virtual/libintl
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3[X]
	x11-libs/pango
	caja? ( >=mate-base/caja-1.17.1 )
	magic? ( sys-apps/file )
	packagekit? ( app-admin/packagekit-base )
	!!app-arch/mate-file-archiver"

DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-util/glib-utils
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
${PN} is a frontend for several archiving utilities. If you want
support for a particular archive format,install the relevant package:

7-zip   : emerge app-arch/p7zip
ace     : emerge app-arch/unace
arj     : emerge app-arch/arj
cpio    : emerge app-arch/cpio
deb     : emerge app-arch/dpkg
iso     : emerge app-cdr/cdrtools
jar,zip : emerge app-arch/zip  or  emerge app-arch/unzip
lha     : emerge app-arch/lha
lzma    : emerge app-arch/xz-utils
lzop    : emerge app-arch/lzop
rar     : emerge app-arch/unrar
rpm     : emerge app-arch/rpm
unstuff : emerge app-arch/stuffit
zoo     : emerge app-arch/zoo"

src_configure() {
	mate_src_configure \
		--disable-run-in-place \
		$(use_enable caja caja-actions) \
		$(use_enable magic) \
		$(use_enable packagekit)
}

src_install() {
	mate_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	mate_pkg_postinst
	readme.gentoo_print_elog
}
