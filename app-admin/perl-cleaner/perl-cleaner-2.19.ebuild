# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/perl-cleaner/perl-cleaner-2.19.ebuild,v 1.3 2015/04/04 22:44:17 vapier Exp $

EAPI=5

DESCRIPTION="User land tool for cleaning up old perl installs"
HOMEPAGE="http://www.gentoo.org/proj/en/perl/"

if [[ "${PV}" == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="http://github.com/gentoo-perl/perl-cleaner.git"
else
	SRC_URI="mirror://gentoo/${P}.tar.bz2 http://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.bz2"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

[[ "${PV}" == "9999" ]] && DEPEND="sys-apps/help2man"

RDEPEND="app-shells/bash
	|| ( >=sys-apps/coreutils-8.15 app-misc/realpath sys-freebsd/freebsd-bin )
	dev-lang/perl
	|| (
		( sys-apps/portage app-portage/portage-utils )
		sys-apps/pkgcore
		sys-apps/paludis
	)
"

src_install() {
	dosbin perl-cleaner
	doman perl-cleaner.1
}
