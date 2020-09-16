# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=GAAS
DIST_VERSION=1.20
inherit perl-module

DESCRIPTION="Parse Adobe Font Metric files"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-text/htmldoc
	)
"
src_test() {
	METRICS="${EPREFIX}/usr/share/htmldoc/fonts" perl-module_src_test
}
