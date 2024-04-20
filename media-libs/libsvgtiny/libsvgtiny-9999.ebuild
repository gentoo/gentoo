# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 netsurf

DESCRIPTION="Small and portable C library to parse SVG"
HOMEPAGE="https://www.netsurf-browser.org/projects/libsvgtiny/"
EGIT_REPO_URI="https://git.netsurf-browser.org/${PN}.git"

LICENSE="MIT"
SLOT="0/${PV}"

RDEPEND="
	>=net-libs/libdom-9999[xml]
	dev-libs/libwapcaplet"
DEPEND="${RDEPEND}
	dev-util/gperf"
BDEPEND="
	>=dev-build/netsurf-buildsystem-1.9-r2
	virtual/pkgconfig"

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
