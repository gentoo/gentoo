# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/usermode-utilities/usermode-utilities-20070815-r3.ebuild,v 1.5 2013/05/12 23:52:16 vapier Exp $

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="Tools for use with Usermode Linux virtual machines"
HOMEPAGE="http://user-mode-linux.sourceforge.net/"
SRC_URI="http://user-mode-linux.sourceforge.net/uml_utilities_${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="fuse"

RDEPEND="fuse? ( sys-fs/fuse )
	sys-libs/readline"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/tools-${PV}

src_prepare() {
	# Merge previous patches with fix for bug #331099
	epatch "${FILESDIR}"/${P}-rollup.patch
	# Fix owner of humfsify; bug #364531
	epatch "${FILESDIR}"/${P}-humfsify-owner.patch
	sed -i -e 's:-o \$(BIN):$(LDFLAGS) -o $(BIN):' "${S}"/*/Makefile || die "LDFLAGS sed failed"
	sed -i -e 's:-o \$@:$(LDFLAGS) -o $@:' "${S}"/moo/Makefile || die "LDFLAGS sed (moo) failed"
	if ! use fuse; then
		einfo "Skipping build of umlmount to avoid sys-fs/fuse dependency."
		sed -i -e 's/\<umlfs\>//' Makefile || die "sed to remove sys-fs/fuse dependency failed"
	fi
}

src_compile() {
	tc-export AR CC
	emake CFLAGS="${CFLAGS} ${CPPFLAGS} -DTUNTAP -D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE -g -Wall" all
}
