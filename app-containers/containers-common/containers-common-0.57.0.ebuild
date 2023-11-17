# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Common config files and docs for Containers stack"
HOMEPAGE="https://github.com/containers/common"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/common.git"
else
	SRC_URI="https://github.com/containers/common/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P#containers-}"
	KEYWORDS="~amd64 ~arm64 ~riscv"
fi

LICENSE="Apache-2.0"
SLOT="0"
RESTRICT="test"
RDEPEND="
	app-containers/containers-image
	app-containers/containers-storage
	app-containers/containers-shortnames
	!<app-containers/podman-4.5.0-r1
	net-firewall/nftables
	net-firewall/iptables[nftables]
	|| ( app-containers/crun app-containers/runc )
	|| (
		( >=app-containers/netavark-1.6.0 >=app-containers/aardvark-dns-1.6.0 )
		>=app-containers/cni-plugins-0.9.1
	)
"

BDEPEND="
	>=dev-go/go-md2man-2.0.2
"

src_prepare() {
	default

	[[ -f docs/Makefile && -f Makefile ]] || die
	sed -i -e 's|/usr/local|/usr|g;' docs/Makefile Makefile || die

	# add comments to mounts.conf
	eapply "${FILESDIR}/examplify-mounts-conf.patch"
}

src_compile() {
	emake docs
}

src_install() {
	emake DESTDIR="${ED}" install

	insinto /etc/containers
	# https://github.com/containers/skopeo/raw/main/default-policy.json
	doins pkg/config/containers.conf "${FILESDIR}/policy.json"

	insinto /etc/containers/registries.d
	# https://github.com/containers/skopeo/raw/main/default.yaml
	doins "${FILESDIR}/default.yaml"

	insinto /usr/share/containers
	doins pkg/seccomp/seccomp.json pkg/subscriptions/mounts.conf

	keepdir /etc/containers/certs.d /etc/containers/oci/hooks.d /etc/containers/systemd /var/lib/containers/sigstore
}
