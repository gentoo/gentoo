# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="Neural network architecture for profacc"
HOMEPAGE="https://rostlab.org/"
SRC_URI="ftp://rostlab.org/profnet/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="sys-libs/libunwind"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed \
		-e '/$@/s:-o:$(LDFLAGS) -o:g' \
		-i src-phd/Makefile || die
}

src_compile() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/862921
	# No upstream bug. Upstream link seemingly doesn't provide any information
	# about this specific project.
	filter-lto

	append-fflags $(test-flags-FC -fallow-argument-mismatch)
	emake \
		F77="$(tc-getF77)" \
		FFLAGS="${FFLAGS}"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		prefix="${EPREFIX}/usr" \
		install

	# Don't install compressed man pages
	find "${ED}"/usr/share/man -type f -name '*.gz' -exec gzip -d {} \; || die
}
