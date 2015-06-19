# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmacaroons/libmacaroons-0.2.0-r1.ebuild,v 1.1 2015/01/15 05:47:45 patrick Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

# Tests can't function after 2014-12-31 ...
RESTRICT="test"

DESCRIPTION="Hyperdex macaroons support library"

HOMEPAGE="http://hyperdex.org"
SRC_URI="http://hyperdex.org/src/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test +python"

RDEPEND="dev-libs/libsodium
	dev-libs/json-c"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="test? ( python )"

src_prepare() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	econf $(use_enable python python-bindings)
}

src_test() {
	emake -j1 check || die
}
