# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Inputlirc daemon to utilize /dev/input/event*"
HOMEPAGE="https://github.com/ferdinandhuebner/inputlirc"
SRC_URI="http://gentooexperimental.org/~genstef/dist/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install || die "emake install failed"

	newinitd "${FILESDIR}"/inputlircd.init  inputlircd
	newconfd "${FILESDIR}"/inputlircd.conf  inputlircd
}
