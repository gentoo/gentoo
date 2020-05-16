# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Package Changes Analyzer (pkgdiff)"
HOMEPAGE="https://github.com/lvc/pkgdiff"
EGIT_REPO_URI="https://github.com/lvc/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

DEPEND=">=dev-lang/perl-5"
RDEPEND="${DEPEND}
	sys-apps/diffutils
	app-text/wdiff
	sys-apps/gawk
	sys-devel/binutils
"

src_compile() {
	:
}

PREFIX="/usr"

src_install() {
	mkdir -p "${D}${PREFIX}"
	perl Makefile.pl -install --destdir "${ED}" || die "install failed"
}
