# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion sysroot

DESCRIPTION="kubernetes yaml and helm chart static analysis tool"
HOMEPAGE="https://kubelinter.io"
SRC_URI="https://github.com/stackrox/kube-linter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=dev-lang/go-1.25.5"

src_prepare() {
	default
	sed -i -e "s/-race//" Makefile || die
	# Doesn't pass in ebuild env
	sed -e 's/TestCreateContextsWithIgnorePaths/_&/' -i pkg/lintcontext/create_contexts_test.go || die
}

src_compile() {
	ego build -o kube-linter ./cmd/kube-linter

	einfo "generating shell completion files"
	sysroot_try_run_prefixed ./kube-linter completion bash > ${PN}.bash || die
	sysroot_try_run_prefixed ./kube-linter completion zsh > ${PN}.zsh || die
	sysroot_try_run_prefixed ./kube-linter completion fish > ${PN}.fish || die
}

src_test() {
	emake test
}

src_install() {
	dobin kube-linter
	dodoc -r config.yaml.example docs/*

	[[ -s ${PN}.bash ]] && newbashcomp ${PN}.bash ${PN}
	[[ -s ${PN}.zsh ]] && newzshcomp ${PN}.zsh _${PN}
	[[ -s ${PN}.fish ]] && dofishcomp ${PN}.fish
}
