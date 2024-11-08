# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A user-friendly launcher for Bazel written in Go"
HOMEPAGE="https://github.com/bazelbuild/bazelisk/"
SRC_URI="
	https://github.com/bazelbuild/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	https://dev.gentoo.org/~xgqt/distfiles/deps/${P}-deps.tar.xz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+bazel-symlink"

DOCS=( CONTRIBUTING.md README.md )

src_compile() {
	mkdir -p bin || die

	local go_ldflags="-X main.BazeliskVersion=${PV}"
	local -a go_buildargs=(
		-ldflags "${go_ldflags}"
		-o bin
	)
	ego build "${go_buildargs[@]}"
}

src_install() {
	exeinto /usr/bin
	doexe "bin/${PN}"

	if use bazel-symlink ; then
		dosym -r /usr/bin/bazelisk /usr/bin/bazel
	fi

	einstalldocs
}
