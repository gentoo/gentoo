# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="A daemon to execute processes with special privileges in a nosuid environment"
HOMEPAGE="http://s0ftpj.org/projects/sud/index.htm"
SRC_URI="http://s0ftpj.org/projects/sud/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

PATCHES=( "${FILESDIR}"/${PN}-1.3-fix-build-system.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cppflags -D_GNU_SOURCE
	default
}

src_install() {
	default

	doman ilogin.1 sud.1 suz.1
	insinto /etc
	doins miscs/sud.conf*
	newinitd "${FILESDIR}"/sud.rc6 sud
}
