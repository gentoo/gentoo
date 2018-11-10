# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN=Frontier-RPC
MY_PV=0.07b4
MODULE_AUTHOR=KMACLEOD
inherit perl-module

DESCRIPTION="Perform remote procedure calls using extensible markup language"
SRC_URI+=" http://perl-xml.sourceforge.net/xml-rpc/${MY_P}.tar.gz"
HOMEPAGE+=" http://perl-xml.sourceforge.net/xml-rpc/"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	dev-perl/XML-Parser
	dev-perl/libwww-perl
"
DEPEND="${RDEPEND}"
