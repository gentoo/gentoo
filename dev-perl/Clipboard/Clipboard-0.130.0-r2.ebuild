# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=KING
MODULE_VERSION=0.13
inherit perl-module

DESCRIPTION="Copy and paste with any OS"

SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86"
IUSE=""

# See bug 521890.
PATCHES=(
	"${FILESDIR}"/"${P}"-insecure-tempfile.patch
)

RDEPEND="x11-misc/xclip"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
