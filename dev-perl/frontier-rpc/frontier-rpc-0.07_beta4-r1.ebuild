# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/frontier-rpc/frontier-rpc-0.07_beta4-r1.ebuild,v 1.1 2014/08/24 02:01:52 axs Exp $

EAPI=5

MY_PN=Frontier-RPC
MY_PV=0.07b4
MODULE_AUTHOR=KMACLEOD
inherit perl-module

DESCRIPTION="Perform remote procedure calls using extensible markup language"
SRC_URI+=" http://perl-xml.sourceforge.net/xml-rpc/${MY_P}.tar.gz"
HOMEPAGE+=" http://perl-xml.sourceforge.net/xml-rpc/"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	dev-perl/XML-Parser
	dev-perl/libwww-perl
"
DEPEND="${RDEPEND}"
