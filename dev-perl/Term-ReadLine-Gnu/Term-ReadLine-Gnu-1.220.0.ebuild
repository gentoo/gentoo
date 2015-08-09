# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=HAYASHI
MODULE_VERSION=${PV:0:4}
inherit perl-module

DESCRIPTION="GNU Readline XS library wrapper"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=sys-libs/readline-6.2"
RDEPEND="${DEPEND}"

mymake=( PASTHRU_DEFINE="-Dxrealloc=_rl_realloc -Dxmalloc=_rl_malloc -Dxfree=_rl_free" )

SRC_TEST="do parallel"
