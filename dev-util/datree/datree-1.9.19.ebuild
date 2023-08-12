# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo go-module shell-completion

DESCRIPTION="Tool to ensure K8s manifests and Helm charts follow best practices"
HOMEPAGE="https://hub.datree.io/
	https://github.com/datreeio/datree/"
SRC_URI="
	https://github.com/datreeio/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz
	https://dev.gentoo.org/~xgqt/distfiles/deps/${P}-deps.tar.xz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md examples )

src_compile() {
	local go_ldflags="
		-s
		-w
		-X github.com/datreeio/datree/cmd.CliVersion=${PV}
	"
	local -a go_buildargs=(
		-ldflags "${go_ldflags}"
	)
	ego build "${go_buildargs[@]}"

	local -a shell_types=(
		bash
		fish
		zsh
	)
	local shell_type
	for shell_type in ${shell_types[@]} ; do
		edo ./datree completion ${shell_type} > ${PN}.${shell_type}
	done
}

src_install() {
	exeinto /usr/bin
	doexe ${PN}

	dofishcomp ${PN}.fish
	newbashcomp ${PN}.bash ${PN}
	newzshcomp ${PN}.zsh _${PN}

	einstalldocs
}
