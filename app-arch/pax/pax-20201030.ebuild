# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit unpacker toolchain-funcs flag-o-matic

DESCRIPTION="pax (Portable Archive eXchange) is the POSIX standard archive tool"
HOMEPAGE="https://www.mirbsd.org/pax.htm"
SRC_URI="https://www.mirbsd.org/MirOS/dist/mir/cpio/paxmirabilis-${PV}.cpio.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 sparc x86"

RDEPEND="elibc_musl? ( sys-libs/fts-standalone )"
DEPEND="${RDEPEND}"
BDEPEND="$(unpacker_src_uri_depends)"

S=${WORKDIR}/${PN}

src_configure() {
	use elibc_musl && append-libs -lfts

	tc-export CC
	tc-getPROG SIZE size
}

src_compile() {
	set -- sh ./Build.sh
	echo "$@"
	"$@"
}

src_install() {
	dobin pax
	doman pax.1

	dosym pax /usr/bin/paxcpio
	newman cpio.1 paxcpio.1

	dosym pax /usr/bin/paxtar
	newman tar.1 paxtar.1
}
