# Copyright 2018-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Large Linux console font (suitable for word processing)"
HOMEPAGE="https://github.com/talamus/solarize-12x29-psf"

MY_PN="${PN}-12x29-psf"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/talamus/${MY_PN}.git"
else
	EGIT_COMMIT="8a856fdb22bc633fdba490b339ea97ef16b700ac"
	SRC_URI="https://github.com/talamus/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${MY_PN}-${EGIT_COMMIT}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~x86"
	S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/consolefonts
	doins Solarize.12x29.psfu.gz
	einstalldocs
}
