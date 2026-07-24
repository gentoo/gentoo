# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion sysroot

GIT_HASH=d253adffe00042d99e7bd7cdcd1d6d2abc3d750d
# checkout the tag and run `git log -1 --no-show-signature --pretty=%ct`
SOURCE_DATE_EPOCH=1780697990

DESCRIPTION="container signing utility"
HOMEPAGE="https://sigstore.dev"
SRC_URI="https://github.com/sigstore/cosign/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

BDEPEND=">=dev-lang/go-1.26.0"

src_compile() {
	emake \
		GIT_HASH=${GIT_HASH} \
		GIT_VERSION=v${PV} \
		GIT_TREESTATE=clean \
		SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH}

	einfo "generating shell completion files"
	sysroot_try_run_prefixed ./cosign completion bash > ${PN}.bash || die
	sysroot_try_run_prefixed ./cosign completion zsh > ${PN}.zsh || die
	sysroot_try_run_prefixed ./cosign completion fish > ${PN}.fish || die
}

src_install() {
	dobin cosign
	einstalldocs
	dodoc CHANGELOG.md

	[[ -s ${PN}.bash ]] && newbashcomp ${PN}.bash ${PN}
	[[ -s ${PN}.zsh ]] && newzshcomp ${PN}.zsh _${PN}
	[[ -s ${PN}.fish ]] && dofishcomp ${PN}.fish
}
