# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/remake/remake-4.1.1.1.ebuild,v 1.2 2015/07/20 11:28:18 vapier Exp $

EAPI="5"

MY_P="${PN}-${PV:0:3}+dbg${PV:4}"

DESCRIPTION="patched version of GNU make that adds improved error reporting, tracing, and a debugger"
HOMEPAGE="http://bashdb.sourceforge.net/remake/"
SRC_URI="mirror://sourceforge/bashdb/${MY_P}.tar.bz2"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="readline"

RDEPEND="readline? ( sys-libs/readline:0= )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	use readline || export vl_cv_lib_readline=no
	default
}

src_install() {
	default
	# delete files GNU make owns and remake doesn't care about.
	rm -r "${ED}"/usr/include || die
}
