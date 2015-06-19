# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pv/pv-1.5.7.ebuild,v 1.9 2014/11/04 09:23:17 ago Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Pipe Viewer: a tool for monitoring the progress of data through a pipe"
HOMEPAGE="http://www.ivarch.com/programs/pv.shtml"
SRC_URI="http://www.ivarch.com/programs/sources/${P}.tar.bz2"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc64-solaris ~x86-solaris"
IUSE="debug nls"

PV_LINGUAS=( de fr pl pt )
IUSE+=" ${PV_LINGUAS[@]/#/linguas_}"

DOCS=( README doc/NEWS doc/TODO )

src_prepare() {
	sed -i configure -e 's|CFLAGS="-g -Wall"|:|g' || die
	# These should produce the same end result (working `pv`).
	sed -i \
		-e 's:$(LD) $(LDFLAGS) -o:$(AR) rc:' \
		autoconf/make/modules.mk~ || die
}

src_configure() {
	tc-export AR
	local lingua
	for lingua in ${PV_LINGUAS[@]}; do
		if ! use linguas_${lingua}; then
			sed -i configure -e "/ALL_LINGUAS=/s:${lingua}::g" || die
		fi
	done
	econf $(use_enable debug debugging) $(use_enable nls)
}

src_test() {
	sed -i -e 's:usleep 200000 || ::g' tests/019-remote-cksum || die
	default
}
