# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Use any Linux distribution inside your terminal (powered by docker/podman)"
HOMEPAGE="https://distrobox.it/
	https://github.com/89luca89/distrobox/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/89luca89/${PN}"
else
	SRC_URI="https://github.com/89luca89/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="GPL-3"  # GPL-3.0-only !
SLOT="0"
IUSE="gui"

RDEPEND="
	|| (
		app-containers/docker
		app-containers/podman
	)
"

src_install() {
	sh ./install --prefix "${ED}/usr" || die "${PN} install script failed"

	if use gui ; then
		:
	else
		rm -r "${ED}/usr/share/icons" || die
	fi

	dodoc *.md
}

pkg_postinst() {
	if use gui ; then
		xdg_icon_cache_update
		xdg_desktop_database_update
	fi
}

pkg_postrm() {
	if use gui ; then
		xdg_icon_cache_update
		xdg_desktop_database_update
	fi
}
