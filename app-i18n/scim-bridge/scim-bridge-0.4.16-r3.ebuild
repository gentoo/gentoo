# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit autotools eutils gnome2-utils multilib readme.gentoo-r1

DESCRIPTION="Yet another IM-client of SCIM"
HOMEPAGE="http://www.scim-im.org/projects/scim_bridge"
SRC_URI="mirror://sourceforge/scim/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86"
IUSE="doc gtk qt4"

RESTRICT="test"

RDEPEND="
	>=app-i18n/scim-1.4.6
	gtk? (
		>=x11-libs/gtk+-2.2:2
		>=x11-libs/pango-1.1
	)
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qtcore:4
		>=x11-libs/pango-1.1
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	doc? ( app-doc/doxygen )
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
If you would like to use ${PN} as default instead of scim, set
$ export GTK_IM_MODULE=scim-bridge
$ export QT_IM_MODULE=scim-bridge
"

PATCHES=(
	"${FILESDIR}/${PN}-0.4.15.2-qt4.patch"
	"${FILESDIR}/${PN}-0.4.15.2-gcc43.patch"
	"${FILESDIR}/${P}+gcc-4.4.patch"
	"${FILESDIR}/${P}+gcc-4.7.patch"
	"${FILESDIR}/${P}-configure.ac.patch" #280887
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=""
	# '--disable-*-immodule' are b0rked, bug #280887

	if use gtk ; then
		myconf="${myconf} --enable-gtk2-immodule=yes"
	else
		myconf="${myconf} --enable-gtk2-immodule=no"
	fi

	# Qt3 is no longer supported, bug 283429
	myconf="${myconf} --enable-qt3-immodule=no"

	if use qt4 ; then
		myconf="${myconf} --enable-qt4-immodule=yes"
	else
		myconf="${myconf} --enable-qt4-immodule=no"
	fi

	econf \
		--disable-static \
		$(use_enable doc documents) \
		${myconf}
}

src_install() {
	default
	prune_libtool_files --modules
	readme.gentoo_create_doc
}

pkg_postinst() {
	use gtk && gnome2_query_immodules_gtk2
	readme.gentoo_print_elog
}

pkg_postrm() {
	use gtk && gnome2_query_immodules_gtk2
}
