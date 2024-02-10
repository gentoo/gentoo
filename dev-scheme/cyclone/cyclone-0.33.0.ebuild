# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Cyclone is a self-hosting Scheme to C compiler
# cyclone-bootstrap is the Cyclone SOURCE transpiled by it to C

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="R7RS Scheme to C compiler"
HOMEPAGE="http://justinethier.github.io/cyclone/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/justinethier/${PN}-bootstrap.git"
else
	SRC_URI="https://github.com/justinethier/${PN}-bootstrap/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-bootstrap-${PV}"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="dev-libs/concurrencykit"
RDEPEND="${DEPEND}"

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
	einstalldocs

	emake PREFIX="/usr" DESTDIR="${D}" install
}
