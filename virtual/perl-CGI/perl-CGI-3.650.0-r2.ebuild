# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-CGI/perl-CGI-3.650.0-r2.ebuild,v 1.1 2015/06/13 12:30:52 dilfridge Exp $

EAPI=5

DESCRIPTION="Virtual for ${PN#perl-}"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x64-macos"
IUSE=""

RDEPEND="
	~dev-perl/${PN#perl-}-${PV}
"

# this is the version included in dev-lang/perl-5.20
# CGI was first released with perl 5.004, deprecated (will be CPAN-only) in v5.19.7 and removed from v5.21.0
# move to dev-perl when 5.18 leaves the tree
