# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DJHD
DIST_VERSION=0.0801
inherit perl-module

DESCRIPTION="Interface to Sphinx-II speech recognition"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-accessibility/sphinx2"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

src_configure() {
	local myconf="--sphinx-prefix=/usr"
	perl-module_src_configure
}
