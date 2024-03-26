# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Use any Linux distribution inside your terminal (powered by docker/podman)"
HOMEPAGE="https://distrobox.privatedns.org/
	https://github.com/89luca89/distrobox/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/89luca89/${PN}.git"
else
	SRC_URI="https://github.com/89luca89/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="GPL-3"  # GPL-3.0-only !
SLOT="0"

RDEPEND="
	|| (
		app-containers/docker
		app-containers/podman
	)
"

src_install() {
	sh ./install --prefix "${ED}/usr" || die "${PN} install script failed"

	dodoc *.md
}
