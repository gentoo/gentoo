# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="User land tool for cleaning up old perl installs"
HOMEPAGE="https://www.gentoo.org/proj/en/perl/"

if [[ "${PV}" == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gentoo-perl/perl-cleaner.git"
else
	SRC_URI="mirror://gentoo/${P}.tar.bz2 https://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

[[ "${PV}" == "9999" ]] && DEPEND="sys-apps/help2man"

RDEPEND="app-shells/bash
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
