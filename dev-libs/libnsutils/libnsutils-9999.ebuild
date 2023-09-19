# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 netsurf

DESCRIPTION="C library for base64 and time"
HOMEPAGE="https://www.netsurf-browser.org/"

EGIT_REPO_URI="https://git.netsurf-browser.org/${PN}.git"
LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS=""
IUSE=""

BDEPEND="dev-util/netsurf-buildsystem"

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
