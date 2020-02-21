# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="generate javascript to dom bindings from w3c webidl files"
HOMEPAGE="http://www.netsurf-browser.org/"
SRC_URI="https://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
IUSE=""

DEPEND="
	dev-util/netsurf-buildsystem
	virtual/yacc"

_emake() {
	source /usr/share/netsurf-buildsystem/gentoo-helpers.sh
	netsurf_define_makeconf
	emake "${NETSURF_MAKECONF[@]}" COMPONENT_TYPE=binary $@
}

src_compile() {
	_emake
}

src_install() {
	_emake DESTDIR="${ED}" install
}
