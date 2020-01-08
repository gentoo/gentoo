# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit bash-completion-r1 eutils

DESCRIPTION="Generate or check digests or MACs of files"
HOMEPAGE="http://mcrypt.hellug.gr/shash/"
SRC_URI="ftp://mcrypt.hellug.gr/pub/mcrypt/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="static"

DEPEND=">=app-crypt/mhash-0.8.18-r1"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-manpage-fixes.patch
	epatch "${FILESDIR}"/${P}-binary-files.patch
}

src_configure() {
	econf $(use_enable static static-link)
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog INSTALL NEWS doc/sample.shashrc doc/FORMAT
	newbashcomp "${FILESDIR}"/shash.bash-completion ${PN}
}
