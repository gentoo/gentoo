# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/fts-standalone/fts-standalone-0.2.ebuild,v 1.1 2015/07/13 23:45:48 blueness Exp $

EAPI="5"

MY_P=${P/-standalone/}

DESCRIPTION="Standalone fts library for use with mus"
HOMEPAGE="http://dev.gentoo.org/~blueness/fts-standalone"
SRC_URI="http://dev.gentoo.org/~blueness/fts-standalone/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~x86"
IUSE=""

DEPEND="
	!sys-libs/glibc
	!sys-libs/uclibc"

S="${WORKDIR}/${MY_P}"
