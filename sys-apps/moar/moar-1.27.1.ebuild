# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-env go-module

DESCRIPTION="Pager designed to do the right thing without any configuration"
HOMEPAGE="https://github.com/walles/moar"
SRC_URI="https://github.com/walles/moar/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="BSD-2 BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"
IUSE="test"
RESTRICT="!test? ( test )"

# moarvm: https://github.com/walles/moar/issues/143
RDEPEND="!dev-lang/moarvm"
BDEPEND="
	test? (
		app-arch/bzip2
		app-arch/xz-utils
	)
"

src_unpack() {
	default

	if [[ -d "${WORKDIR}"/vendor ]] ; then
		mv "${WORKDIR}"/vendor "${S}"/vendor || die
	fi
	go-env_set_compile_environment
}

src_compile() {
	# https://github.com/walles/moar/blob/master/build.sh#L28
	ego build -ldflags="-w -X main.versionString=${PV}" -o moar
}

src_test() {
	# From test.sh (we don't run that because it has some linting etc)
	ego test -timeout 20s ./...
}

src_install() {
	dobin moar
	doman moar.1
	einstalldocs
}
