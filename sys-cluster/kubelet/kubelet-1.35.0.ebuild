# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-env go-module shell-completion sysroot systemd

DESCRIPTION="Kubernetes Node Agent"
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

RDEPEND="selinux? ( sec-policy/selinux-kubernetes )"
BDEPEND=">=dev-lang/go-1.25.4"

QA_PRESTRIPPED=usr/bin/kubelet

src_compile() {
	local GOOS=$(go-env_goos)

	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
		emake -j1 GOFLAGS="${GOFLAGS}" GOLDFLAGS="" LDFLAGS="" FORCE_HOST_GO=yes \
		KUBE_BUILD_PLATFORMS="${GOOS}/${GOARCH}" KUBE_${GOOS@U}_${GOARCH@U}_CC="${CC}" \
		WHAT=cmd/${PN}

	bin=_output/local/bin/${GOOS}/${GOARCH}/${PN}

	einfo "generating shell completion files"
	sysroot_try_run_prefixed ${bin} completion bash > ${PN}.bash || die
	sysroot_try_run_prefixed ${bin} completion zsh > ${PN}.zsh || die
	sysroot_try_run_prefixed ${bin} completion fish > ${PN}.fish || die
}

src_install() {
	dobin ${bin}

	[[ -s ${PN}.bash ]] && newbashcomp ${PN}.bash ${PN}
	[[ -s ${PN}.zsh ]] && newzshcomp ${PN}.zsh _${PN}
	[[ -s ${PN}.fish ]] && dofishcomp ${PN}.fish

	keepdir /etc/kubernetes/manifests /var/log/kubelet /var/lib/kubelet
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotated ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	insinto /etc/kubernetes
	newins "${FILESDIR}"/${PN}.env ${PN}.env
}
