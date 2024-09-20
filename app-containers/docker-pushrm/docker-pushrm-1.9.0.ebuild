# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Docker CLI plugin to update container repository documentation"
HOMEPAGE="https://github.com/docker/buildx"
SRC_URI="
	https://github.com/christian-korneck/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	https://dev.gentoo.org/~xgqt/distfiles/deps/${P}-deps.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-containers/docker-cli
"

src_compile() {
	local -a go_build_opts=(
		-o ./bin/
	)
	ego build "${go_build_opts[@]}"
}

src_install() {
	exeinto /usr/libexec/docker/cli-plugins
	doexe "bin/${PN}"

	einstalldocs
}
