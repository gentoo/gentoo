# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Java API compliance checker"
HOMEPAGE="https://github.com/lvc/japi-compliance-checker"
EGIT_REPO_URI="https://github.com/lvc/japi-compliance-checker.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""

DEPEND=">=dev-lang/perl-5"
RDEPEND="${DEPEND}
	>=virtual/jdk-1.8:*
"

src_compile() {
	:
}

PREFIX="/usr"

src_install() {
	mkdir -p "${D}${PREFIX}"
	perl Makefile.pl -install --destdir "${D}" || die "install failed"
}
