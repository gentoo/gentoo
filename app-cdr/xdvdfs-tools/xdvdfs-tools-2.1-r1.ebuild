# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Tools for manipulating Xbox ISO images"
HOMEPAGE="http://www.layouts.xbox-scene.com/"
SRC_URI="http://www.layouts.xbox-scene.com/main/files/XDVDFSToolsv${PV}.rar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="|| ( app-arch/unrar app-arch/rar )"
RDEPEND=""

S=${WORKDIR}/XDVDFS_Tools/src

src_unpack() {
	unpack ${A}
	mv "XDVDFS Tools" XDVDFS_Tools
	sed -i \
		-e '/^LDFLAGS = -s/d' \
		-e '/^CCFLAGS =/s:=.*:= ${CFLAGS} ${CPPFLAGS}:g' \
		-e "/^CC =/s:=.*:=$(tc-getCC):" \
		"${S}"/makefile.prefab
	epatch "${FILESDIR}"/${P}-fnamefix.patch
	mkdir "${S}"/xdvdfs_extract/output "${S}"/xdvdfs_maker/output
}

src_compile() {
	local d
	for d in xdvdfs_{dumper,extract,maker} ; do
		emake -C ${d} || die
	done
}

src_install() {
	dobin xdvdfs_dumper/output/xdvdfs_dumper || die "xdvdfs_dumper"
	dobin xdvdfs_extract/output/xdvdfs_extract || die "xdvdfs_extract"
	dobin xdvdfs_maker/output/xdvdfs_maker || die "xdvdfs_maker"
	dohtml ../documentation/*.htm
	dodoc ../Readme.txt
}
