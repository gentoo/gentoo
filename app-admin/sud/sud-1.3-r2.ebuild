# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="A daemon to execute processes with special privileges in a nosuid environment"
HOMEPAGE="http://www.s0ftpj.org/projects/sud/index.htm"
SRC_URI="http://www.s0ftpj.org/projects/sud/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="elibc_musl? ( sys-libs/queue-standalone )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3-fix-build-system.patch
	"${FILESDIR}"/${PN}-1.3-use-system-queue.patch
)

src_prepare() {
	default

	# bug #713470
	rm sud/queue.h || die

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
