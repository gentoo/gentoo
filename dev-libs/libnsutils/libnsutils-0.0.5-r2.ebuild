# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit netsurf

DESCRIPTION="base64 and time library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/"
SRC_URI="https://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
IUSE=""

DEPEND="dev-util/netsurf-buildsystem"

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
