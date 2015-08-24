# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_P=${P/-standalone/}

DESCRIPTION="Standalone fts library for use with musl"
HOMEPAGE="https://dev.gentoo.org/~blueness/fts-standalone"
SRC_URI="https://dev.gentoo.org/~blueness/fts-standalone/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ~ppc ~x86"
IUSE=""

DEPEND="
	!sys-libs/glibc
	!sys-libs/uclibc"

S="${WORKDIR}/${MY_P}"
