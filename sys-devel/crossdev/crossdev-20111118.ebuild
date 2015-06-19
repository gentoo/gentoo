# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/crossdev/crossdev-20111118.ebuild,v 1.3 2015/04/25 16:38:01 floppym Exp $

EAPI="3"

if [[ ${PV} == "99999999" ]] ; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/crossdev.git"
	inherit git-2
	SRC_URI=""
	#KEYWORDS=""
else
	SRC_URI="mirror://gentoo/${P}.tar.xz
		http://dev.gentoo.org/~vapier/dist/${P}.tar.xz"
	KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
fi

DESCRIPTION="Gentoo Cross-toolchain generator"
HOMEPAGE="http://www.gentoo.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=">=sys-apps/portage-2.1
	app-shells/bash
	!sys-devel/crossdev-wrappers"
DEPEND="app-arch/xz-utils"

src_install() {
	emake install DESTDIR="${D}" || die
}
