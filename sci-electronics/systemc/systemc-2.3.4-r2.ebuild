# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV}_pub_rev_20190614"

inherit autotools toolchain-funcs

DESCRIPTION="A C++ based modeling platform for VLSI and system-level co-design"
HOMEPAGE="
	https://systemc.org
	https://github.com/accellera-official/systemc
"

if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/accellera-official/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/accellera-official/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~riscv ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="debug doc examples static-libs"
REQUIRED_USE="examples? ( doc )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.4-arch-pthreads-fallback.patch
	"${FILESDIR}"/${PN}-2.3.4-riscv-int64.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf CXX="$(tc-getCXX)" \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		--with-unix-layout
}

src_install() {
	default
	if use doc; then
		if use examples; then
			docompress -x /usr/share/doc/"${PF}"/examples
		else
			rm -r "${ED}"/usr/share/doc/"${PF}"/examples || die
		fi
	else
		rm -r "${ED}"/usr/share/doc/"${PF}" || die
	fi

	if ! use static-libs; then
		find "${ED}" -name "*.la" -delete || die
	fi
}
