# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A libsass command line driver"
HOMEPAGE="https://github.com/sass/sassc"
SRC_URI="https://github.com/sass/sassc/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 x86 ~amd64-linux"

RDEPEND=">=dev-libs/libsass-3.6.5:="
DEPEND="${RDEPEND}"

DOCS=( Readme.md )

src_prepare() {
	default
	[[ -f VERSION ]] || echo "${PV}" > VERSION
	eautoreconf
}
