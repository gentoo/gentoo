# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A generic preprocessor"
HOMEPAGE="https://logological.org/gpp https://github.com/logological/gpp"
SRC_URI="https://github.com/logological/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

src_prepare() {
	default
	eautoreconf
}
