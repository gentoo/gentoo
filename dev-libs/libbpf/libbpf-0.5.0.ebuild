# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

if [[ ${PV} =~ [9]{4,} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/libbpf/libbpf.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~riscv ~s390 sparc x86"
fi
S="${WORKDIR}/${P}/src"

DESCRIPTION="Stand-alone build of libbpf from the Linux kernel"
HOMEPAGE="https://github.com/libbpf/libbpf"

LICENSE="GPL-2 LGPL-2.1 BSD-2"
SLOT="0/${PV}"
IUSE="static-libs"

DEPEND="
	sys-kernel/linux-headers
	virtual/libelf"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/libbpf-9999-paths.patch
)

src_configure() {
	append-cflags -fPIC
	tc-export CC AR
	export LIBSUBDIR="$(get_libdir)"
	export V=1
}

src_install() {
	emake \
		DESTDIR="${D}" \
		install install_uapi_headers

	if ! use static-libs; then
		find "${ED}" -name '*.a' -delete || die
	fi

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
}
