# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=GAAS
DIST_VERSION=0.13
inherit perl-module

DESCRIPTION="Convert between most 8bit encodings"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-perl/Unicode-String-2.60.0"
DEPEND="${RDEPEND}"
