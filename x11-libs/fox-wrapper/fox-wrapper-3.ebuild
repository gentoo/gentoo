# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="wrapper for fox-config to manage multiple versions"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND=""
DEPEND=""

S=${WORKDIR}

src_install() {
	exeinto /usr/lib/misc
	newexe "${FILESDIR}"/fox-wrapper-${PV}.sh fox-wrapper.sh

	dodir /usr/bin
	dosym ../lib/misc/fox-wrapper.sh /usr/bin/fox-config
}
