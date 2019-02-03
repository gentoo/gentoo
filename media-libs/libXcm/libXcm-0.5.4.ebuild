# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = *9999 ]]; then
	GITECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/oyranos-cms/libxcm.git"
fi
inherit autotools multilib-minimal ${GITECLASS}
unset GITECLASS

DESCRIPTION="Reference implementation of the X Color Management specification"
HOMEPAGE="http://www.oyranos.org/libxcm/"
[[ ${PV} != *9999 ]] && \
SRC_URI="https://github.com/oyranos-cms/${PN,,}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86"
IUSE="static-libs X"

RDEPEND="
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/libXmu[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

[[ ${PV} != *9999 ]] && S="${WORKDIR}/${P,,}"

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with X x11)
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -delete || die
}
