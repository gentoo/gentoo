# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Manages Ruby on Rails symlinks"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="https://dev.gentoo.org/~flameeyes/ruby-team/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.0"

src_unpack() {
	unpack ${A}
	# Fix/Add Prefix support
	sed -i -e 's/\${ROOT}/${EROOT}/' *.eselect || die
}

src_install() {
	insinto /usr/share/eselect/modules
	doins *.eselect || die "doins failed"
}
