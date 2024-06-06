# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs go-module edo unpacker

DESCRIPTION="Build APK packages from source code using declarative pipelines"
HOMEPAGE="https://github.com/chainguard-dev/melange/"
SRC_URI="
	https://github.com/chainguard-dev/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	https://dev.gentoo.org/~xgqt/distfiles/deps/${P}-deps.tar.xz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"                         # Does not work inside Portage sandbox.

CHECKREQS_DISK_BUILD="1800M"

DOCS=( NEWS.md README.md examples )

pkg_setup() {
	check-reqs_pkg_setup
}

src_compile() {
	local -a -r go_buildopts=(
		-o ./
	)
	ego build "${go_buildopts[@]}"
}

src_test() {
	local -a -r melange_opts=(
		./pkg/sca/testdata/go-fips-bin/go-fips-bin.yaml
		--arch="$(uname -m)"
		--generate-index=false
		--out-dir=pkg/sca/testdata/go-fips-bin/packages/
		--source-dir=pkg/sca/testdata/go-fips-bin/
	)
	edo ./melange build "${melange_opts[@]}"
}

src_install() {
	exeinto /usr/bin
	doexe melange

	einstalldocs
	docompress -x "/usr/share/doc/${PF}/examples"
}
