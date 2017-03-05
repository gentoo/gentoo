# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=TBUSCH
MODULE_VERSION=${PV%0.0}
inherit perl-module

DESCRIPTION="Perl interface to the JavaScript Engine"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-perl/Log-Log4perl
	>=dev-lang/spidermonkey-1.5:0"
DEPEND="${RDEPEND}
	dev-perl/ExtUtils-PkgConfig"

src_prepare() {
	epatch "${FILESDIR}"/mozjs185.patch
	perl-module_src_prepare
}

SRC_TEST=do
