# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/detox/detox-1.2.0-r3.ebuild,v 1.3 2015/06/26 09:03:06 ago Exp $

EAPI=5

inherit eutils

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Safely remove spaces and strange characters from filenames"
HOMEPAGE="http://detox.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ~ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}"/${MY_P}

RDEPEND="dev-libs/popt"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison"

PATCHES=(
	"${FILESDIR}"/${P}-parallel.patch
	"${FILESDIR}"/${P}-LDFLAGS.patch
	"${FILESDIR}"/${P}-change-default-sequence-to-use-utf8-table.patch
	"${FILESDIR}"/${P}-install-missing-file.patch
	"${FILESDIR}"/${P}-format-security.patch
	)

src_prepare() {
	sed \
		-e 's:Fl c Ar:Fl f Ar:g' \
		-i ${PN}.1 || die
	epatch "${PATCHES[@]}"
	sed \
		-e '/detoxrc.sample/d' \
		-i Makefile.in || die
}

src_configure() {
	econf --with-popt="${EPREFIX}/usr"
}
