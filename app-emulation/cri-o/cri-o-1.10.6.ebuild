# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_COMMIT="56d7d9a0750d7deb06182361837b690683f13dfe"
EGO_PN="github.com/kubernetes-incubator/${PN}"

inherit golang-vcs-snapshot systemd

DESCRIPTION="OCI-based implementation of Kubernetes Container Runtime Interface"
HOMEPAGE="https://cri-o.io/"
SRC_URI="https://github.com/kubernetes-incubator/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="btrfs +device-mapper ostree seccomp selinux"

COMMON_DEPEND="
	app-crypt/gpgme:=
	app-emulation/runc
	dev-libs/glib:=
	dev-libs/libassuan:=
	dev-libs/libgpg-error:=
	net-firewall/conntrack-tools
	net-firewall/iptables
	net-misc/cni-plugins
	net-misc/socat
	sys-apps/iproute2
	btrfs? ( sys-fs/btrfs-progs )
	device-mapper? ( sys-fs/lvm2:= )
	ostree? ( dev-util/ostree )
	seccomp? ( sys-libs/libseccomp:= )
	selinux? ( sys-libs/libselinux:= )"
DEPEND="
	${COMMON_DEPEND}
	dev-go/go-md2man"
RDEPEND="${COMMON_DEPEND}"
S="${WORKDIR}/${P}/src/${EGO_PN}"

src_prepare() {
	default

	sed -e '/^GIT_.*/d' \
		-e 's/$(GO) build -i/$(GO) build -v -work -x/' \
		-e 's/\${GIT_COMMIT}/'${EGIT_COMMIT}'/' \
		-i Makefile || die

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

	[[ -f hack/ostree_tag.sh ]] || die
	use ostree || { echo -e "#!/bin/sh\necho containers_image_ostree_stub" > \
		hack/ostree_tag.sh || die; }

	[[ -f hack/seccomp_tag.sh ]] || die
	use seccomp || { echo -e "#!/bin/sh\ntrue" > \
		hack/seccomp_tag.sh || die; }

	[[ -f hack/selinux_tag.sh ]] || die
	use selinux || { echo -e "#!/bin/sh\ntrue" > \
		hack/selinux_tag.sh || die; }

	mkdir -p bin || die
	GOPATH="${WORKDIR}/${P}" GOBIN="${WORKDIR}/${P}/bin" \
		emake binaries docs
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${D}${EPREFIX}/usr" install.bin install.man

	keepdir /etc/crio
	insinto /etc/crio
	use seccomp && doins seccomp.json

	"${ED}"/usr/bin/crio --config="" config --default > "${T}"/crio.conf.example || die
	doins   "${T}/crio.conf.example"

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

	systemd_dounit contrib/systemd/*
}
