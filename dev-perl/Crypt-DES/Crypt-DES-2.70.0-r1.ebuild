# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DPARIS
DIST_VERSION=2.07
inherit perl-module

DESCRIPTION="Perl DES encryption module"

LICENSE="DES"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="test"

DEPEND="test? ( dev-perl/Crypt-CBC )"

export OPTIMIZE="${CFLAGS}"
