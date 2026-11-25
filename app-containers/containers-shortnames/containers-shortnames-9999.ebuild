# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Configures default shortnames (aliases) for Containers"
HOMEPAGE="https://github.com/containers/shortnames"
GIT_COMMIT="e893043ee00c29ac1083b2151d4fb287d939a9fc"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/shortnames.git"
else
	SRC_URI="https://github.com/containers/shortnames/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN#containers-}-${GIT_COMMIT}"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv"
fi

LICENSE="Apache-2.0"
SLOT="0"
RDEPEND="!<app-containers/buildah-1.44.0
	!<app-containers/podman-6.0.0
	!<app-containers/skopeo-1.23"

src_install() {
	insinto /usr/share/containers/registries.conf.d
	newins shortnames.conf 000-shortnames.conf
}
