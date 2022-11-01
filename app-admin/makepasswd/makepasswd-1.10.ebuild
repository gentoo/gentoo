# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Random password generator"
HOMEPAGE="https://packages.debian.org/stable/admin/makepasswd"
SRC_URI="mirror://debian/dists/potato/main/source/admin/${P/-/_}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="dev-lang/perl"

src_install() {
	dobin makepasswd
	doman makepasswd.1
	einstalldocs
}
