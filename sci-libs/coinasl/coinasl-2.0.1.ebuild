# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Ampl Solver Library (ASL)"
HOMEPAGE="https://github.com/coin-or-tools/ThirdParty-ASL"
SOLVERS_SHA="64919f75f"
SRC_URI="https://coin-or-tools.github.io/ThirdParty-ASL/solvers-${SOLVERS_SHA}.tgz
	https://github.com/coin-or-tools/ThirdParty-ASL/archive/refs/tags/releases/${PV}.tar.gz -> ${P}.tar.gz"
IUSE="big-goff-32 big-goff-64 static-libs"
REQUIRED_USE="big-goff-32? ( !big-goff-64 )
	big-goff-64? ( !big-goff-32 )"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/ThirdParty-ASL-releases-${PV}"

PATCHES=(
	"${FILESDIR}/${P}-getrusage.patch"
	"${FILESDIR}/${P}-dtoa.patch"
)

src_unpack() {
	default
	mv solvers "${S}" || die
}

src_compile() {
	local myeconfargs=(
		$(use_enable static-libs static)
		--enable-shared
	)
	local arch_intsize=32
	use amd64 && arch_intsize=64
	use big-goff-32 && myeconfargs+=( --with-intsize=32 )
	use big-goff-64 && myeconfargs+=( --with-intsize=64 )
	! use big-goff-32 && ! use big-goff-64 && myeconfargs+=( --with-intsize=${arch_intsize} )
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	! use static-libs && rm "${D}/usr/$(get_libdir)/libcoinasl.la"
}
