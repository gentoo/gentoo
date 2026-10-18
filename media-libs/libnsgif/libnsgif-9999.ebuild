# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit git-r3 netsurf

DESCRIPTION="Decoding library for the GIF image file format, written in C"
HOMEPAGE="https://www.netsurf-browser.org/projects/libnsgif/"

EGIT_REPO_URI="git://git.netsurf-browser.org/${PN}.git"
LICENSE="MIT"
# The soname is $PV, which usually means it can't be trusted, which
# ironically means that it's the correct subslot.
SLOT="0/${PV}"

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
