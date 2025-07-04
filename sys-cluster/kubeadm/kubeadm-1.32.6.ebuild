# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module toolchain-funcs shell-completion

DESCRIPTION="CLI to Easily bootstrap a secure Kubernetes cluster"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/archive/v${PV}.tar.gz -> kubernetes-${PV}.tar.gz"
S=${WORKDIR}/kubernetes-${PV}

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="hardened selinux"
RESTRICT="test"

RDEPEND="app-containers/cri-tools
	selinux? ( sec-policy/selinux-kubernetes )"
BDEPEND=">=dev-lang/go-1.23.3"

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" FORCE_HOST_GO=yes \
		emake -j1 GOFLAGS="${GOFLAGS}" GOLDFLAGS="" LDFLAGS="" WHAT=cmd/${PN}

	if ! tc-is-cross-compiler; then
		einfo "generating shell completion files"
		_output/bin/${PN} completion bash > ${PN}.bash || die
		_output/bin/${PN} completion zsh > ${PN}.zsh || die
	fi
}

src_install() {
	dobin _output/bin/${PN}

	if ! tc-is-cross-compiler; then
		newbashcomp ${PN}.bash ${PN}
		newzshcomp ${PN}.zsh _${PN}
	else
		ewarn "Shell completion files not installed! Install them manually with '${PN} completion --help'"
	fi
}
