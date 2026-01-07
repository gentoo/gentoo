# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AIZVORSKI
inherit perl-module

DESCRIPTION="Convert between color spaces"
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-perl/Graphics-ColorNames-0.320.0
"
BDEPEND="${RDEPEND}
"

src_install() {
	perl-module_src_install
	docompress -x usr/share/doc/${PF}/examples/
	insinto usr/share/doc/${PF}/
	doins -r examples
}
