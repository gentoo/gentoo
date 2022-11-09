# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT=afa0c576fcafc095e2827261e412fadabb016874

inherit go-module

DESCRIPTION="OCI-based implementation of Kubernetes Container Runtime Interface"
HOMEPAGE="https://cri-o.io/"
SRC_URI="https://github.com/cri-o/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="btrfs +device-mapper selinux systemd"

COMMON_DEPEND="
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
	systemd? ( sys-apps/systemd:= )"
DEPEND="
	${COMMON_DEPEND}
	dev-go/go-md2man"
RDEPEND="${COMMON_DEPEND}
	!<app-containers/podman-1.3.2-r1"

src_prepare() {
	default

	sed -e '/^export GOPROXY=/d' \
		-e '/^GIT_.*/d' \
		-e '/	git diff --exit-code/d' \
		-e 's/$(GO) build -i/$(GO) build -v -work -x/' \
		-e 's/\${GIT_COMMIT}/'${EGIT_COMMIT}'/' \
		-e "s|^GIT_COMMIT := .*|GIT_COMMIT := ${EGIT_COMMIT}|" \
		-e "s|^COMMIT_NO := .*|COMMIT_NO := ${EGIT_COMMIT}|" \
		-i Makefile || die

	echo ".NOTPARALLEL: binaries docs" >> Makefile || die

	sed -e 's:/usr/local/bin:/usr/bin:' \
		-i contrib/systemd/* || die
}

src_compile() {
	[[ -f hack/btrfs_installed_tag.sh ]] || die
	use btrfs || { echo -e "#!/bin/sh\necho exclude_graphdriver_btrfs" > \
		hack/btrfs_installed_tag.sh || die; }

	[[ -f hack/libdm_installed.sh ]] || die
	use device-mapper || { echo -e "#!/bin/sh\necho exclude_graphdriver_devicemapper" > \
		hack/libdm_installed.sh || die; }

	[[ -f hack/selinux_tag.sh ]] || die
	use selinux || { echo -e "#!/bin/sh\ntrue" > \
		hack/selinux_tag.sh || die; }

	mkdir -p bin || die
	emake all \
		GOBIN="${S}/bin" \
		GO_BUILD="go build ${GOFLAGS}" \
		GO_MD2MAN="$(which go-md2man)"
}

src_install() {
	emake install install.config install.systemd \
		DESTDIR="${D}" \
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
	doins contrib/cni/99-loopback.conf
}
