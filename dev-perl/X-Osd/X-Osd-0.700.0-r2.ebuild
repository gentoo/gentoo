# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=GOZER
DIST_VERSION=0.7
inherit perl-module virtualx

DESCRIPTION="Perl glue to libxosd (X OnScreen Display)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/xosd"
RDEPEND="${DEPEND}"

src_test() {
	virtx perl-module_src_test
}
