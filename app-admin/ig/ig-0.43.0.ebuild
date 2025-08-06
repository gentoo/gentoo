# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Tools and framework for data collection and system inspection using eBPF"
HOMEPAGE="https://github.com/inspektor-gadget/inspektor-gadget"
SRC_URI="https://github.com/inspektor-gadget/inspektor-gadget/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/inspektor-gadget/inspektor-gadget/releases/download/v${PV}/inspektor-gadget-vendor-v${PV}.tar.gz"

S="${WORKDIR}/inspektor-gadget-${PV}"

LICENSE="Apache-2.0 GPL-2 MIT BSD-2 MPL-2.0 ISC imagemagick CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_compile() {
	ego build \
		-ldflags "-X github.com/inspektor-gadget/inspektor-gadget/internal/version.version=v${PV} \
		-X github.com/inspektor-gadget/inspektor-gadget/cmd/common/image.builderImage=ghcr.io/inspektor-gadget/gadget-builder:v${PV}" \
		-tags "netgo" \
		./cmd/ig
}

src_install() {
	dobin ig
	einstalldocs
}
