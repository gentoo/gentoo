# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/bareos-fastlzlib/bareos-fastlzlib-0_pre20140912.ebuild,v 1.1 2014/09/16 19:38:49 mschiff Exp $

EAPI=5

inherit eutils

DESCRIPTION="bareos fork of zlib-like interface to fast block compression (LZ4 or FastLZ) libraries"
HOMEPAGE="https://github.com/bareos/fastlzlib"
SRC_URI="http://dev.gentoo.org/~mschiff/distfiles/${P}.zip"

LICENSE="BSD-1 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	!app-arch/lz4
"

S="${WORKDIR}/fastlzlib-master"

src_install() {
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -delete
	find "${D}" -type d -name libfastlz -exec rm -rf {} +
}
