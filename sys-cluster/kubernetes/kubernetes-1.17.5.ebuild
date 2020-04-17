# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module systemd

DESCRIPTION="production-grade container orchestration"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

AGENT="kubelet"
CLI="kubeadm kubectl"
SERVICES="kube-apiserver kube-controller-manager kube-proxy kube-scheduler"
IUSE="hardened"
for x in ${AGENT} ${CLI} ${SERVICES}; do
	IUSE+=" +${x}"
done

BDEPEND=">=dev-lang/go-1.13"
COMMON_DEPEND="
	kube-apiserver? (
		acct-group/kube-apiserver
		acct-user/kube-apiserver
	)
	kube-controller-manager? (
		acct-group/kube-controller-manager
		acct-user/kube-controller-manager
	)
	kube-scheduler? (
		acct-group/kube-scheduler
		acct-user/kube-scheduler
	)"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	kube-proxy? ( net-firewall/conntrack-tools )
	!sys-cluster/kubeadm
	!sys-cluster/kubectl
	!sys-cluster/kubelet
	!sys-cluster/kube-apiserver
	!sys-cluster/kube-controller-manager
	!sys-cluster/kube-proxy
	!sys-cluster/kube-scheduler"

RESTRICT+=" test"

src_compile() {
	local x
	for x in ${AGENT} ${CLI} ${SERVICES}; do
		use $x || continue
		CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
			emake -j1 GOFLAGS=-v GOLDFLAGS="" LDFLAGS="" WHAT=cmd/${x}
	done
}

src_install() {
	local x
	for x in ${AGENT} ${CLI} ${SERVICES}; do
		use $x || continue
		dobin _output/bin/${x}
		if has ${x} ${CLI}; then
		_output/bin/${x} completion bash > ${x}.bash || die
		_output/bin/${x} completion zsh > ${x}.zsh || die
			newbashcomp ${x}.bash ${x}
			insinto /usr/share/zsh/site-functions
			newins ${x}.zsh _${x}
			continue
		fi
		newinitd "${FILESDIR}"/${x}.initd ${x}
		newconfd "${FILESDIR}"/${x}.confd ${x}
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/${x}.logrotated ${x}
		keepdir /var/log/${x}
		if [[ "$x" =~ kubelet ]]; then
			systemd_dounit "${FILESDIR}"/${x}.service
			insinto /etc/kubernetes
			newins "${FILESDIR}"/${x}.env ${x}.env
			keepdir /etc/kubernetes/manifests
		fi
		if [[ $x =~ kubelet|kube-proxy ]]; then
			keepdir /var/lib/${x}
		fi
		if [[ $x =~ .*apiserver|.*controller-manager|.*scheduler ]]; then
			fowners ${x}:${x} /var/log/${x}
		fi
	done
}
