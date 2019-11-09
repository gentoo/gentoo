# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P=cluster-${PV}
MAJ_PV=$(ver_cut 1)
MIN_PV=$(ver_cut 2-3)

DESCRIPTION="A library for cluster management common to the various pieces of Cluster Suite"
HOMEPAGE="https://sourceware.org/cluster/wiki/"
SRC_URI="ftp://sourceware.org/pub/cluster/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="!sys-cluster/cman-headers
	!sys-cluster/cman-kernel
	!=sys-cluster/cman-1*"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/${PN/-//}

src_configure() {
	cd "${WORKDIR}"/${MY_P} || die
	./configure \
		--cc="$(tc-getCC)" \
		--libdir=/usr/$(get_libdir) \
		--cflags="-Wall" \
		--disable_kernel_check \
		--somajor="$MAJ_PV" \
		--sominor="$MIN_PV" \
		|| die "configure problem"

	sed -e 's:\($(CC)\):\1 $(LDFLAGS):' \
		-i Makefile "${WORKDIR}/${MY_P}/make/cobj.mk" || die
}

src_compile() {
	emake clean all
}
