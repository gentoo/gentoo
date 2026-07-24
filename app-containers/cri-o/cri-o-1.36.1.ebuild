# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

EGIT_COMMIT=75a79851f912e67647903fddddcb65ae1bfdabeb

inherit go-module

DESCRIPTION="OCI-based implementation of Kubernetes Container Runtime Interface"
HOMEPAGE="https://cri-o.io/"
SRC_URI="https://github.com/cri-o/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="btrfs +device-mapper selinux systemd"

DEPEND="
	app-crypt/gpgme:=
	app-containers/conmon
	app-containers/runc
	dev-libs/glib:=
	dev-libs/libassuan:=
	dev-libs/libgpg-error:=
	net-firewall/conntrack-tools
	net-firewall/iptables
	app-containers/cni-plugins
	net-misc/socat
	sys-apps/iproute2
	sys-libs/libseccomp:=
	btrfs? ( sys-fs/btrfs-progs )
	device-mapper? ( sys-fs/lvm2:= )
	selinux? ( sys-libs/libselinux:= )
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="${DEPEND}
	!<app-containers/podman-1.3.2-r1
	selinux? ( sec-policy/selinux-crio )
"
BDEPEND="
	dev-go/go-md2man
	>=dev-lang/go-1.26.3
	sys-apps/which
"

src_prepare() {
	default

	echo ".NOTPARALLEL: binaries docs" >> Makefile || die

	sed -e '/STRIP/d' -e 's/ -Werror / /' -i pinns/Makefile || die

	sed -e 's:/usr/local/bin:/usr/bin:' \
		-i contrib/systemd/* || die
}

src_compile() {
	[[ -f hack/btrfs_installed_tag.sh ]] || die
	use btrfs || { echo -e "#!/bin/sh\necho exclude_graphdriver_btrfs" > \
		hack/btrfs_installed_tag.sh || die; }

	[[ -f hack/selinux_tag.sh ]] || die
	use selinux || { echo -e "#!/bin/sh\ntrue" > \
		hack/selinux_tag.sh || die; }

	mkdir -p bin || die
	emake all \
		GOBIN="${S}/bin" \
		GO_BUILD="go build ${GOFLAGS}" \
		BUILD_COMMIT="${EGIT_COMMIT}" \
		SHRINKFLAGS="-w" \
		GO_MD2MAN="$(which go-md2man)"
}

src_install() {
	emake install install.config install.systemd \
		DESTDIR="${D}" \
		BUILD_COMMIT="${EGIT_COMMIT}" \
		GO_MD2MAN="$(which go-md2man)" \
		PREFIX="${D}${EPREFIX}/usr"
	keepdir /etc/crio
	mv "${ED}/etc/crio/crio.conf"{,.example} || die

	newinitd "${FILESDIR}/crio.initd" crio

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"

	# Suppress crio log error messages triggered if these don't exist.
	keepdir /etc/containers/oci/hooks.d
	keepdir /usr/share/containers/oci/hooks.d

	# Suppress crio "Missing CNI default network" log message.
	keepdir /etc/cni/net.d
	insinto /etc/cni/net.d
	doins contrib/cni/99-loopback.conflist
}
