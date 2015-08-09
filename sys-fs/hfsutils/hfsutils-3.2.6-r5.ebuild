# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="HFS FS Access utils"
HOMEPAGE="http://www.mars.org/home/rob/proj/hfs/"
SRC_URI="ftp://ftp.mars.org/pub/hfs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 sparc x86"
IUSE="tcl tk"

DEPEND="
	tcl? ( dev-lang/tcl:0= )
	tk? ( dev-lang/tk:0= )"
RDEPEND="${DEPEND}"

# use tk requires tcl - bug #150437
REQUIRED_USE="tk? ( tcl )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-errno.patch \
		"${FILESDIR}"/largerthan2gb.patch \
		"${FILESDIR}"/${P}-fix-tcl-8.6.patch
}

src_configure() {
	econf $(use_with tcl) $(use_with tk)
}

src_compile() {
	emake AR="$(tc-getAR) rc" CC="$(tc-getCC)" RANLIB="$(tc-getRANLIB)"
	emake CC="$(tc-getCC)" -C hfsck
}

src_install() {
	dodir /usr/bin /usr/lib /usr/share/man/man1
	emake \
		prefix="${D}"/usr \
		MANDEST="${D}"/usr/share/man \
		infodir="${D}"/usr/share/info \
		install
	dobin hfsck/hfsck
	dodoc BLURB CHANGES README TODO doc/*.txt
}
