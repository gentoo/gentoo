# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Cyclone is a self-hosting Scheme to C compiler
# cyclone-bootstrap is the Cyclone source transpiled by it to C.

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="R7RS Scheme to C compiler"
HOMEPAGE="http://justinethier.github.io/cyclone/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/justinethier/${PN}-bootstrap.git"
else
	SRC_URI="https://github.com/justinethier/${PN}-bootstrap/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}"/${PN}-bootstrap-${PV}
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="dev-libs/concurrencykit"
DEPEND="${RDEPEND}"

src_configure() {
	export CYC_GCC_OPT_FLAGS="${CFLAGS}"
	append-cflags -fPIC -Iinclude
	append-ldflags -L.
	tc-export AR CC RANLIB
}

src_compile() {
	local myopts=(
		PREFIX="/usr"
		CYC_GCC_OPT_FLAGS="${CYC_GCC_OPT_FLAGS}"
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		RANLIB="$(tc-getRANLIB)"
	)
	emake "${myopts[@]}"
}

src_test() {
	emake LDFLAGS="" test
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install
	einstalldocs
}
