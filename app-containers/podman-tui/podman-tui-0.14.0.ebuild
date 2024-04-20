# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module
DESCRIPTION="Terminal UI frontend for Podman"
HOMEPAGE="https://github.com/containers/podman-tui"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/podman-tui.git"
else
	SRC_URI="https://github.com/containers/podman-tui/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

# main pkg
LICENSE="Apache-2.0"
# deps
LICENSE+=" BSD-2 BSD MIT MPL-2.0"
SLOT="0"
RESTRICT="test"
RDEPEND="
	>=app-containers/podman-4.0.2
"

src_compile() {
	# parse tags from Makefile & make them comma-seperated as space-seperated list is deprecated
	local BUILDTAGS=$(grep 'BUILDTAGS :=' Makefile | awk -F\" '{ print $2; }' | sed -e 's| |,|g;')
	ego build -tags "${BUILDTAGS}"
}

src_install() {
	dobin "${PN}"
	einstalldocs
}
