# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CGI-Emulate-PSGI/CGI-Emulate-PSGI-0.150.0-r1.ebuild,v 1.1 2014/08/26 17:37:36 axs Exp $

EAPI=5

MODULE_AUTHOR=MIYAGAWA
MODULE_VERSION=0.15
inherit perl-module

DESCRIPTION="PSGI adapter for CGI"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/HTTP-Message
"
DEPEND="${RDEPEND}
"

SRC_TEST=do

src_install() {
	perl-module_src_install
	rm "${ED}"/usr/share/doc/${PF}/README.mkdn || die
}
