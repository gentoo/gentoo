# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix

DESCRIPTION="User land tool for cleaning up old perl installs"
HOMEPAGE="https://www.gentoo.org/proj/en/perl/"

if [[ "${PV}" == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gentoo-perl/perl-cleaner.git"
else
	SRC_URI="mirror://gentoo/${P}.tar.bz2 https://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
# TODO: Detect at runtime what's available and fallback if needed, possibly
# integrate with eselect-package-manager, bug #779007.
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
