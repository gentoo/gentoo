# Copyright 1999-2023 Gentoo Authors
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
IUSE="btrfs"

# there are no test files so prevent tests
RESTRICT="test"
RDEPEND="
	app-containers/podman[btrfs?]
"
DEPEND="${RDEPEND}"

src_compile() {
	export BUILDFLAGS=" -tags exclude_graphdriver_devicemapper"
	use !btrfs && BUILDFLAGS+=",exclude_graphdriver_btrfs,btrfs_noversion"
	default
}

src_install() {
	emake DESTDIR="${ED}/usr/bin" install
	systemd_dounit "contrib/systemd/prometheus-podman-exporter.service"
	systemd_douserunit "contrib/systemd/prometheus-podman-exporter.service"
	einstalldocs
}
