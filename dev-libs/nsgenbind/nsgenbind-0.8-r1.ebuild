# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit netsurf

DESCRIPTION="Generate Javascript-to-DOM bindings from w3c webidl files"
HOMEPAGE="http://www.netsurf-browser.org/"
SRC_URI="https://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64"
IUSE=""

BDEPEND="
	dev-util/netsurf-buildsystem
	virtual/yacc"

_emake() {
	netsurf_define_makeconf
	emake "${NETSURF_MAKECONF[@]}" COMPONENT_TYPE=binary $@
}

src_compile() {
	_emake
}

src_install() {
	_emake DESTDIR="${D}" install
}
