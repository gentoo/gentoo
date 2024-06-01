# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="suid, sgid file and directory checking"
HOMEPAGE="https://linukz.org/sxid.shtml https://github.com/taem/sxid"
SRC_URI="https://linukz.org/download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="selinux"

RDEPEND="
	virtual/mailx
	selinux? ( sec-policy/selinux-sxid )
"

pkg_postinst() {
	elog "You will need to configure sxid.conf for your system using the manpage and example"
}
