# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Autoresponder add on package for qmailadmin"
HOMEPAGE="http://www.inter7.com/software/"
SRC_URI="http://qmail.ixip.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~s390 ~sh ~sparc ~x86"

RDEPEND="virtual/qmail"
PATCHES=(
	"${FILESDIR}/${P}-no-include-bounce.patch"
)
DOCS=( README help_message qmail-auto )

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install () {
	into /var/qmail
	dobin autorespond
	doman *.1
	einstalldocs
}

pkg_postinst() {
	ewarn "Please note that original messages are now NOT included with bounces"
	ewarn "by default. Use the flag per the help output if you want them."
}
