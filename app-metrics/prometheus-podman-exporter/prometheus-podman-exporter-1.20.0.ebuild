# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Exporter for podman giving containers, pods, images, volumes & networks metrics"
HOMEPAGE="https://github.com/containers/prometheus-podman-exporter"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/prometheus-podman-exporter.git"
else
	SRC_URI="https://github.com/containers/prometheus-podman-exporter/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

# Main package
LICENSE="Apache-2.0"
# Dependencies
LICENSE+=" BSD-2 BSD ISC MIT MPL-2.0"

SLOT="0"
IUSE="btrfs systemd"

# there are no test files so prevent tests
RESTRICT="test"

DEPEND="
	app-crypt/gpgme:1=
	btrfs? ( sys-fs/btrfs-progs )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.10.1-gentoo-systemd.patch"
)

src_compile() {
	export BUILDTAGS=""
	use !btrfs && BUILDTAGS+=",exclude_graphdriver_btrfs"
	use systemd && BUILDTAGS+=",systemd"
	default
}

src_install() {
	emake DESTDIR="${ED}/usr/bin" install
	dosym -r /usr/bin/"${PN}" /usr/bin/podman_exporter

	insinto /etc/default
	newins "contrib/systemd/system/prometheus-podman-exporter.sysconfig" "${PN}"
	systemd_dounit "contrib/systemd/system/prometheus-podman-exporter.service"
	systemd_douserunit "contrib/systemd/user/prometheus-podman-exporter.service"
	dosym prometheus-podman-exporter.service $(systemd_get_systemunitdir)/podman_exporter.service
	dosym prometheus-podman-exporter.service $(systemd_get_userunitdir)/podman_exporter.service

	newconfd "contrib/openrc/prometheus-podman-exporter.confd" "${PN}"
	newinitd "contrib/openrc/prometheus-podman-exporter.initd" "${PN}"
	dosym "${PN}" /etc/conf.d/podman_exporter
	dosym "${PN}" /etc/init.d/podman_exporter

	einstalldocs
}
