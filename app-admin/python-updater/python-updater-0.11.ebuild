# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ "${PV}" == "9999" ]]; then
	inherit git-2
fi

DESCRIPTION="Script used to reinstall Python packages after changing active Python versions"
HOMEPAGE="https://www.gentoo.org/proj/en/Python/"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/python-updater.git"
else
	SRC_URI="https://dev.gentoo.org/~floppym/dist/${P}.tar.bz2"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="$([[ "${PV}" == "9999" ]] && echo "sys-apps/help2man")"
RDEPEND="|| ( >=sys-apps/portage-2.1.6 >=sys-apps/paludis-0.56.0 )"

src_compile() {
	if [[ "${PV}" == "9999" ]]; then
		emake ${PN}.1 || die "Generation of man page failed"
	fi
}

src_install() {
	dosbin ${PN}
	doman ${PN}.1
	dodoc AUTHORS
}
