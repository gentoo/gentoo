# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DLAMBLEY
DIST_VERSION=${PV%.0}
inherit perl-module

DESCRIPTION="MogileFS Client using AnyEvent non-blocking IO"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/IO-AIO
	dev-perl/AnyEvent
	dev-perl/AnyEvent-HTTP
	dev-perl/File-Slurp
	>=dev-perl/MogileFS-Client-1.16
	dev-perl/Try-Tiny
	dev-perl/namespace-clean
"
DEPEND="${RDEPEND}"

# Tests only available if you have a local mogilefsd on 127.0.0.1:7001
DIST_TEST=skip

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
