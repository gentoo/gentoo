# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs multilib systemd

DESCRIPTION="openvz tool and a library to control ploop block devices"
HOMEPAGE="http://wiki.openvz.org/Download/ploop"
SRC_URI="http://download.openvz.org/utils/ploop/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug static-libs"

DEPEND="
	dev-libs/libxml2
	virtual/pkgconfig
	"

RDEPEND="dev-libs/libxml2
	!<sys-cluster/vzctl-4.8
	sys-block/parted
	sys-fs/e2fsprogs
	sys-process/lsof
	sys-apps/findutils
	"

DOCS=( tools/README )

src_prepare() {
	epatch "${FILESDIR}/disable_create_run_dir.patch"

	# Respect CFLAGS and CC, do not add debug by default
	sed -i \
		-e 's|CFLAGS =|CFLAGS +=|' \
		-e '/CFLAGS/s/-g -O0 //' \
		-e '/CFLAGS/s/-O2//' \
		-e 's|CC=|CC?=|' \
		-e 's/-Werror//' \
		-e '/DEBUG=yes/d' \
		-e '/LOCKDIR/s/var/run/' \
		Makefile.inc || die 'sed on Makefile.inc failed'
	# Avoid striping of binaries
	sed -e '/INSTALL/{s: -s::}' -i tools/Makefile || die 'sed on tools/Makefile failed'

	# respect AR and RANLIB, bug #452092
	tc-export AR RANLIB
	sed -i -e 's/ranlib/$(RANLIB)/' lib/Makefile || die 'sed on lib/Makefile failed'
}

src_compile() {
	emake CC="$(tc-getCC)" V=1 $(usex debug 'DEBUG' '' '=yes' '')
}

src_install() {
	default
	ldconfig -n "${D}/usr/$(get_libdir)/" || die
}
