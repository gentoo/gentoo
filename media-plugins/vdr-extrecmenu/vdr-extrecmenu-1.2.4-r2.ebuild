# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

GIT_VERSION="77d10faec3c7b0abe25ba3b161dc3b4e2cad042b"

DVDARCHIVE="dvdarchive-2.3-beta.sh"

DESCRIPTION="VDR Plugin: Extended recordings menu"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-extrecmenu"
SRC_URI="https://projects.vdr-developer.org/git/vdr-plugin-extrecmenu.git/snapshot/vdr-plugin-extrecmenu-${GIT_VERSION}.tar.gz -> ${PF}.tar.gz
	mirror://gentoo/${DVDARCHIVE}.gz"
S="${WORKDIR}/vdr-plugin-extrecmenu-${GIT_VERSION}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

DEPEND="media-video/vdr"

src_prepare() {
	rm "${S}"/po/{ca_ES,da_DK,el_GR,et_EE,hr_HR,hu_HU,nl_NL,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po || die

	eapply "${FILESDIR}/${P}_c++11.patch"

	cd "${WORKDIR}" || die
	eapply "${FILESDIR}/${DVDARCHIVE%.sh}-configfile.patch"

	vdr-plugin-2_src_prepare
}

src_install() {
	vdr-plugin-2_src_install

	cd "${WORKDIR}"
	newbin ${DVDARCHIVE} dvdarchive.sh

	insinto /etc/vdr
	doins "${FILESDIR}"/dvdarchive.conf
}
