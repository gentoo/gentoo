# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
fi

inherit mate optfeature

DESCRIPTION="Engrampa archive manager for MATE"
HOMEPAGE="https://mate-desktop.org/ https://github.com/mate-desktop/engrampa"

LICENSE="FDL-1.1+ GPL-2+ LGPL-2+"
SLOT="0"
IUSE="caja magic"

DEPEND="
	>=dev-libs/glib-2.50:2
	>=dev-libs/json-glib-0.14
	virtual/libintl
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3[X]
	x11-libs/libSM
	x11-libs/pango
	caja? ( >=mate-base/caja-1.17.1 )
	magic? ( >=sys-apps/file-5.38 )
"
RDEPEND="
	${DEPEND}
	virtual/libintl
"
BDEPEND="
	app-text/yelp-tools
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	mate_src_configure \
		--disable-run-in-place \
		$(use_enable caja caja-actions) \
		$(use_enable magic) \
		--disable-packagekit
}

pkg_postinst() {
	mate_pkg_postinst

	optfeature "Support for 7-zip" app-arch/p7zip
	optfeature "Support for ace" app-arch/unace
	optfeature "Support for arj" app-arch/arj
	optfeature "Support for cpio" app-alternatives/cpio
	optfeature "Support for deb" app-arch/dpkg
	optfeature "Support for iso" app-cdr/cdrtools
	optfeature "Support for jar,zip" app-arch/zip app-arch/unzip
	optfeature "Support for lha" app-arch/lha
	optfeature "Support for lzma" app-arch/xz-utils
	optfeature "Support for lzop" app-arch/lzop
	optfeature "Support for rar" app-arch/unrar
	optfeature "Support for rpm" app-arch/rpm
	optfeature "Support for unstuff" app-arch/stuffit
	optfeature "Support for zoo" app-arch/zoo
}
