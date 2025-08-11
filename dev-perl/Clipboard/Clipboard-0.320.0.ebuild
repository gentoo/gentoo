# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
DIST_VERSION=0.32
inherit perl-module virtualx

DESCRIPTION="Copy and paste with any OS"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

RDEPEND="
	dev-perl/CGI
	dev-perl/URI
	|| (
		x11-misc/xclip
		x11-misc/xsel
	)
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		x11-misc/xclip
		x11-misc/xsel
	)
"

src_test() {
	virtx perl-module_src_test
}
