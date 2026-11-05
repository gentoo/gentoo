# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit git-r3 netsurf

DESCRIPTION="Framebuffer abstraction library, written in C"
HOMEPAGE="https://www.netsurf-browser.org/projects/librosprite/"
EGIT_REPO_URI="git://git.netsurf-browser.org/${PN}.git"

LICENSE="MIT"
SLOT="0/${PV}"

DEPEND="dev-build/netsurf-buildsystem"

PATCHES=( "${FILESDIR}"/${PN}-0.1.2-Werror.patch )

_emake() {
	netsurf_define_makeconf
	emake "${NETSURF_MAKECONF[@]}" COMPONENT_TYPE=lib-shared $@
}

src_compile() {
	_emake
}

src_install() {
	_emake DESTDIR="${D}" install
}

src_test() {
	_emake test
}
