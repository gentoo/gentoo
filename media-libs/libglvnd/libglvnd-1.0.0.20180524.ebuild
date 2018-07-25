# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/NVIDIA/${PN}.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

PYTHON_COMPAT=( python2_7 )
inherit autotools ${GIT_ECLASS} multilib-minimal python-any-r1

DESCRIPTION="The GL Vendor-Neutral Dispatch library"
HOMEPAGE="https://github.com/NVIDIA/libglvnd"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="~amd64"
	COMMIT="8709003ffdc905d144855c3117a31da220149d4c"
	SRC_URI="https://github.com/NVIDIA/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S=${WORKDIR}/${PN}-${COMMIT}
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	!media-libs/mesa[-libglvnd(-)]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	"
DEPEND="${PYTHON_DEPS}
	${RDEPEND}"

src_unpack() {
	default
	[[ $PV = 9999* ]] && git-r3_src_unpack
}

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
