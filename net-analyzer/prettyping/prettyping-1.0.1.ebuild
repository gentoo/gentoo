# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Ping wrapper that produces coloured, easily readable output."
HOMEPAGE="http://denilson.sa.nom.br/prettyping/"
SRC_URI="https://github.com/denilsonsa/prettyping/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-shells/bash
	net-misc/iputils
	virtual/awk"

src_install() {
	dobin prettyping
}
