# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Note: USE=static-libs isn't great -- only PIC objects are provided.

EAPI="4"

inherit eutils

DESCRIPTION="high level interface to Linux seccomp filter"
HOMEPAGE="http://sourceforge.net/projects/libseccomp/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs tools"

src_prepare() {
	sed -i \
		-e "/^SUBDIRS_BUILD/s:=.*:= src $(usex tools tools ''):" \
		Makefile || die
}

src_test() {
	emake SUBDIRS_BUILD='tools tests'
	cd tests
	./regression
}

src_install() {
	default
	use tools && dobin tools/{bpf_{disasm,sim},sys_{inspector,resolver}}
	use static-libs && dolib.a src/libseccomp.a
}
