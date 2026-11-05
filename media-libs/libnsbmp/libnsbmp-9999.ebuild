# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit git-r3 netsurf

DESCRIPTION="Decoding library for BMP and ICO image file formats, written in C"
HOMEPAGE="https://www.netsurf-browser.org/projects/libnsbmp/"
EGIT_REPO_URI="git://git.netsurf-browser.org/${PN}.git"

LICENSE="MIT"
SLOT="0/${PV}"

BDEPEND="
	dev-build/netsurf-buildsystem
	virtual/pkgconfig"

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
