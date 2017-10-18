# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BJKUIT
DIST_VERSION=0.12
inherit perl-module

DESCRIPTION="LM/NT hashing, for Samba's smbpasswd entries"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

RDEPEND="dev-perl/Digest-MD4"
DEPEND="${RDEPEND}"
