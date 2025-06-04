# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual package for container engine"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~riscv"

RDEPEND="|| (
	>=app-containers/docker-cli-23.0.0
	app-containers/podman[wrapper(+)]
)
"
