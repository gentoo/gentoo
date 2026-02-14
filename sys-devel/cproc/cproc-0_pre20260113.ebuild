# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://git.sr.ht/~mcf/cproc"
	inherit git-r3
else
	CPROC_COMMIT="e963ced5c2b0a102778b19906eaef1af92ed7862"
	CPROC_P="${PN}-${CPROC_COMMIT}"
	SRC_URI="https://git.sr.ht/~mcf/cproc/archive/${CPROC_COMMIT}.tar.gz -> ${CPROC_P}.tar.gz"
	S="${WORKDIR}/${CPROC_P}"

	KEYWORDS="~amd64 ~arm64 ~riscv"
fi

DESCRIPTION="C11 compiler using QBE as backend"
HOMEPAGE="https://sr.ht/~mcf/cproc/"

LICENSE="ISC"
SLOT="0"

DEPEND="sys-devel/qbe"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/cproc-bug969281-const-strchr.patch"
)

src_configure() {
	tc-export CC

	edo ./configure --prefix=/usr
}
