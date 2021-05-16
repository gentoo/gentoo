# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DJHD
MODULE_VERSION=0.0801
inherit perl-module

DESCRIPTION="Interface to Sphinx-II speech recognition"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-accessibility/sphinx2"
RDEPEND="${DEPEND}"

src_configure() {
	local myconf="--sphinx-prefix=/usr"
	perl-module_src_configure
}
