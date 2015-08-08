# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit multilib autotools eutils
if [[ ${PV} == "9999" ]] ; then
	inherit git-2
	EGIT_REPO_URI="git://anongit.freedesktop.org/libqmi"
else
	KEYWORDS="~amd64 ~arm ~mips ~x86"
	SRC_URI="http://cgit.freedesktop.org/libqmi/snapshot/${P}.tar.gz"
fi

DESCRIPTION="QMI modem protocol helper library"
HOMEPAGE="http://cgit.freedesktop.org/libqmi/"

LICENSE="LGPL-2"
SLOT="0"
IUSE="doc static-libs test"

RDEPEND=">=dev-libs/glib-2.32"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.0-python3.patch #464314
	if [[ ! -e configure ]] ; then
		find -name Makefile.am -exec sed -i 's:^INCLUDES:AM_CPPFLAGS:' {} + || die
		sed -i \
			-e 's:noinst_PROGRAMS:check_PROGRAMS:' \
			{cli/test,libqmi-glib/test}/Makefile.am || die
		eautoreconf
	fi
}

src_configure() {
	econf \
		--disable-more-warnings \
		$(use_enable static{-libs,}) \
		$(use_with doc{,s}) \
		$(use_with test{,s})
}

src_install() {
	default
	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/libqmi-glib.la
}
