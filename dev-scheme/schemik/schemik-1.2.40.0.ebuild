# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit toolchain-funcs versionator eutils

DESCRIPTION="High-level lexically-scoped implicitly-parallel dialect of Scheme and Common LISP"
HOMEPAGE="http://schemik.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/boehm-gc
		>=dev-libs/glib-2.0
		sys-libs/readline"

DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-asneeded.patch
	sed -i -e 's/\(COMP_ARGS=\)-g \(-Wall -Winline\) -O2/\1$(CFLAGS) \2/' \
	Makefile || die "patching Makefile failed"
}

src_compile() {
	emake CC=$(tc-getCC)|| die "emake failed"
}

src_install() {
	dobin schemik || die "dobin failed"
	insinto "/usr/share/${PN}/$(get_version_component_range 1-2)"
	doins "scm/base.scm" || die "Standard library installation failed"
	dodoc ChangeLog README || die "dodoc failed"
	doman doc/man/schemik.1.gz || die "doman failed"
}
