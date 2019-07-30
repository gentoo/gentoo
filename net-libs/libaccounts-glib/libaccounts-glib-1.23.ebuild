# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools vcs-snapshot xdg-utils

DESCRIPTION="Accounts SSO (Single Sign-On) management library for GLib applications"
HOMEPAGE="https://01.org/gsso/"
SRC_URI="https://gitlab.com/accounts-sso/libaccounts-glib/repository/archive.tar.gz?ref=VERSION_${PV} -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="debug"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libxml2
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	dev-util/gtk-doc
"

DOCS=( AUTHORS NEWS )

pkg_setup() {
	xdg_environment_reset
}

src_prepare() {
	default
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
	find "${D}" -name '*.la' -delete || die
}
