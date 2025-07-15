# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual package for container engine"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv"

RDEPEND="|| (
	>=app-containers/docker-cli-23.0.0
	app-containers/podman[wrapper(+)]
)
"

pkg_postinst() {
	if has_version "app-containers/podman[wrapper(+)]"; then
		ewarn "podman may have compatibility issues with the docker api."
		ewarn "Please ensure that any issues you face are not related to \
issues with the podman api before filing bug reports in the gentoo bugzilla"
	fi
}
