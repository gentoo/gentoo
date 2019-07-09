# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

SRC_URI="https://github.com/sass/sassc/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux"

DESCRIPTION="A libsass command line driver"
HOMEPAGE="https://github.com/sass/sassc"
LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/libsass:="
DEPEND="${RDEPEND}"

DOCS=( Readme.md )

src_prepare() {
	default
	eautoreconf
}
