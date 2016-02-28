# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils vcs-snapshot

DESCRIPTION="Accounts SSO (Single Sign-On) management library for GLib applications"
HOMEPAGE="https://01.org/gsso/"
SRC_URI="https://gitlab.com/accounts-sso/libaccounts-glib/repository/archive.tar.gz?ref=VERSION_${PV} -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libxml2
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
"

RESTRICT="test"

DOCS=( AUTHORS NEWS )

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--disable-python \
		--disable-tests \
		$(use_enable debug)
}

src_install() {
	default
	prune_libtool_files
}
