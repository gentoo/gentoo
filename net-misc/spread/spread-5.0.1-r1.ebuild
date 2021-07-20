# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="spread-src"

DESCRIPTION="Distributed network messaging system"
HOMEPAGE="http://www.spread.org"
SRC_URI="mirror://gentoo/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="Spread-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/spread
	acct-user/spread
"

src_prepare() {
	default

	# don't strip binaries
	sed -i -e 's/0755 -s/0755/g' daemon/Makefile.in examples/Makefile.in
}

src_install() {
	emake DESTDIR="${D}" docdir="/usr/share/doc/${PF}" install
	newinitd "${FILESDIR}"/spread.init.d spread
}
