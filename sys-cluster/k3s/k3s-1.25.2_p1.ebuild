# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module linux-info systemd

DESCRIPTION="Lightweight Kubernetes"
HOMEPAGE="https://k3s.io"
K3S_CONTAINERD_VERSION=1.6.8-k3s1
K3S_RUNC_VERSION=v1.1.4
K3S_ROOT_VERSION=0.11.0
K3S_TRAEFIK_VERSION=10.19.3
K3S_TRAEFIK_PACKAGE_VERSION=00
K3S_CNIPLUGINS_VERSION=1.1.1
CONFIG_CHECK="~BRIDGE_NETFILTER ~CFS_BANDWIDTH ~CGROUP_DEVICE ~CGROUP_PERF ~CGROUP_PIDS ~IP_VS ~MEMCG ~NETFILTER_XT_MATCH_COMMENT ~OVERLAY_FS ~VLAN_8021Q ~VXLAN"

MY_PV=${PV%_p*}+k3s${PV#*_p}
SRC_URI="https://github.com/zmedico/k3s/archive/refs/tags/v${MY_PV}-vendor.tar.gz -> ${P}-vendor.tar.gz
	${EGO_SUM_SRC_URI}
	https://github.com/k3s-io/containerd/archive/refs/tags/v${K3S_CONTAINERD_VERSION}.tar.gz -> k3s-containerd-${K3S_CONTAINERD_VERSION}.tar.gz
	https://github.com/opencontainers/runc/archive/refs/tags/${K3S_RUNC_VERSION}.tar.gz -> k3s-runc-${K3S_RUNC_VERSION}.tar.gz
	https://helm.traefik.io/traefik/traefik-${K3S_TRAEFIK_VERSION}.tgz
	https://github.com/rancher/plugins/archive/refs/tags/v${K3S_CNIPLUGINS_VERSION}-k3s1.tar.gz -> k3s-cni-plugins-${K3S_CNIPLUGINS_VERSION}.tar.gz
	amd64? ( https://github.com/rancher/k3s-root/releases/download/v${K3S_ROOT_VERSION}/k3s-root-amd64.tar -> k3s-root-amd64-${K3S_ROOT_VERSION}.tar )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+kubectl-symlink rootless"
REQUIRED_USE="|| ( amd64 )"
DEPEND="
	app-misc/yq
	net-firewall/conntrack-tools
	sys-fs/btrfs-progs
	rootless? ( app-containers/slirp4netns )
"
RDEPEND="kubectl-symlink? ( !sys-cluster/kubectl )"
RESTRICT+=" test"

S=${WORKDIR}/${PN}-${MY_PV/+/-}-vendor

src_unpack() {
	unpack ${P}-vendor.tar.gz
	cd "${S}" || die
	mkdir -p bin/aux build/static/charts cache etc || die
	cp "${DISTDIR}/traefik-${K3S_TRAEFIK_VERSION}.tgz" build/static/charts/traefik-${K3S_TRAEFIK_VERSION}${K3S_TRAEFIK_PACKAGE_VERSION}.tgz || die
	cp "${DISTDIR}/k3s-cni-plugins-${K3S_CNIPLUGINS_VERSION}.tar.gz" cache/ || die
}

src_prepare() {
	local filename pattern replacement
	default

	local CONTAINERD_DIR=build/src/github.com/containerd/containerd
	mkdir -p "${CONTAINERD_DIR}" || die
	tar -x --strip-components=1 -f "${DISTDIR}/k3s-containerd-${K3S_CONTAINERD_VERSION}.tar.gz" -C "${CONTAINERD_DIR}" || die
	if has_version -b ">=dev-lang/go-1.18"; then
		# https://bugs.gentoo.org/835601
		sed -i -e "/github.com\/containerd\/containerd => .\/.empty-mod/d" "${CONTAINERD_DIR}"/{go.mod,vendor/modules.txt} || die
	fi

	local RUNC_DIR=build/src/github.com/opencontainers/runc
	mkdir -p "${RUNC_DIR}" || die
	tar -x --strip-components=1 -f "${DISTDIR}/k3s-runc-${K3S_RUNC_VERSION}.tar.gz" -C "${RUNC_DIR}" || die

	# Disable download for files fetched via SRC_URI.
	sed -e 's:^[[:space:]]*curl:#\0:' \
		-e 's:^[[:space:]]*git:#\0:' \
		-e 's:^rm -rf \${CHARTS_DIR}:#\0:' \
		-e 's:^rm -rf \${RUNC_DIR}:#\0:' \
		-e 's:^rm -rf \${CONTAINERD_DIR}:#\0:' \
		-e 's:yq e :yq -r :' \
		-e "s:^setup_tmp\$:TMP_DIR=${S}/build/static/charts:" \
		-i scripts/download || die
	sed -e '/scripts\/build-upload/d' -i scripts/package-cli || die
	pattern='git clone -b $VERSION_CNIPLUGINS https://github.com/rancher/plugins.git $WORKDIR'
	filename=scripts/build
	grep -qF "${pattern}" "${filename}" || \
		die "failed to locate plugins clone command"
	sed -e "s|${pattern}|mkdir -p \"\$WORKDIR\" \\&\\& tar -xzf \"${S}/cache/k3s-cni-plugins-${K3S_CNIPLUGINS_VERSION}.tar.gz\" --strip-components=1 -C \"\$WORKDIR\"|" \
		-e 's|rm -rf $TMPDIR||' \
		-i "${filename}" || die
	sed -e 's:/usr/local/bin:/usr/bin:g' -i k3s.service || die
}

src_compile() {
	mkdir -p build/data || die
	"${BASH}" -ex ./scripts/download || die
	./scripts/build || die
	./scripts/package-cli || die
}

src_install() {
	dobin "dist/artifacts/${PN}"
	use kubectl-symlink && dosym k3s /usr/bin/kubectl
	systemd_dounit "${FILESDIR}/${PN}.service"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	dodoc README.md
}
