# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="https://github.com/sass/sassc.git"
	inherit git-r3
	KEYWORDS=
else
	SRC_URI="https://github.com/sass/sassc/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux"
fi

DESCRIPTION="A libsass command line driver"
HOMEPAGE="https://github.com/sass/sassc"
LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND=">=dev-libs/libsass-3.5:="
DEPEND="${RDEPEND}"

DOCS=( Readme.md )

src_prepare() {
	default

	if [[ ${PV} != *9999 ]]; then
		[[ -f VERSION ]] || echo "${PV}" > VERSION
	fi

	eautoreconf
}
