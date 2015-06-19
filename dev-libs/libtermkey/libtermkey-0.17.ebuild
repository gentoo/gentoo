# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtermkey/libtermkey-0.17.ebuild,v 1.1 2015/02/26 06:03:44 yngwin Exp $

EAPI=5
inherit eutils flag-o-matic multilib

DESCRIPTION="Library for easy processing of keyboard entry from terminal-based programs"
HOMEPAGE="http://www.leonerd.org.uk/code/libtermkey/"
SRC_URI="http://www.leonerd.org.uk/code/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="demos"

RDEPEND="dev-libs/unibilium:="
DEPEND="${RDEPEND}
	sys-devel/libtool
	virtual/pkgconfig
	demos? ( dev-libs/glib:2 )"

src_prepare() {
	if ! use demos; then
		sed -e '/^all:/s:$(DEMOS)::' -i Makefile || die
	fi
}

src_compile() {
	append-flags -fPIC -fPIE
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" all
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		DESTDIR="${D}" install
	prune_libtool_files
}
