# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

DESCRIPTION="Script used to reinstall Python packages after changing active Python versions"
HOMEPAGE="https://www.gentoo.org/proj/en/Python/"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/python-updater.git"
else
	SRC_URI="https://dev.gentoo.org/~floppym/dist/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

if [[ ${PV} == 9999 ]]; then
	DEPEND="
		sys-apps/gentoo-functions
		sys-apps/help2man
	"
fi
RDEPEND="
	sys-apps/gentoo-functions
	|| ( >=sys-apps/portage-2.1.6 >=sys-apps/paludis-0.56.0 sys-apps/pkgcore )
"

src_compile() {
	[[ ${PV} == 9999 ]] && emake python-updater
	default
}
