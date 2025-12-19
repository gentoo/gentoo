# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix

DESCRIPTION="User land tool for cleaning up old perl installs"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Perl"

if [[ "${PV}" == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gentoo-perl/perl-cleaner.git"
else
	SRC_URI="https://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="pkgcore"

[[ "${PV}" == "9999" ]] && BDEPEND="sys-apps/help2man"

RDEPEND="
	app-shells/bash
	dev-lang/perl
	pkgcore? ( sys-apps/pkgcore )
	!pkgcore? (
		app-portage/portage-utils
		sys-apps/portage
	)
"

src_prepare() {
	default
	eprefixify ${PN}
}

src_install() {
	dosbin perl-cleaner
	doman perl-cleaner.1
}
