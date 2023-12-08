# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit php-pear-r2

DESCRIPTION="PHP class to communicate with IRC networks"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="doc examples"
DOCS=( CREDITS FEATURES docs/HOWTO README.md )

src_install() {
	local HTML_DOCS=( )
	use examples && HTML_DOCS+=( docs/examples/ )

	if use doc; then
		DOCS+=( docs/DOCUMENTATION )
		HTML_DOCS+=( docs/HTML/* )
	fi
	php-pear-r2_src_install
}
