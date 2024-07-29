# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 netsurf

DESCRIPTION="decoding library for the GIF image file format, written in C"
HOMEPAGE="https://www.netsurf-browser.org/projects/libnsgif/"

EGIT_REPO_URI="https://git.netsurf-browser.org/${PN}.git"
LICENSE="MIT"
SLOT="0"

BDEPEND="
	dev-build/netsurf-buildsystem
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${PN}-1.0.0-make-test-failures-fatal.patch" )

src_prepare() {
	default
}

_emake() {
	netsurf_define_makeconf
	emake "${NETSURF_MAKECONF[@]}" COMPONENT_TYPE=lib-shared $@
}

src_compile() {
	_emake
}

src_test() {
	_emake test
}

src_install() {
	_emake DESTDIR="${D}" install
}
