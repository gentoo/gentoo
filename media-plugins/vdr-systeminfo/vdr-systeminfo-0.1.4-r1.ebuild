# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: systeminfo"
HOMEPAGE="http://firefly.vdr-developer.org/systeminfo/"
SRC_URI="http://firefly.vdr-developer.org/systeminfo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-2"

RDEPEND="sys-apps/lm-sensors
		app-admin/hddtemp"

src_prepare() {
	vdr-plugin-2_src_prepare

	# Makefile correction, .eclass fails in some Makefiles
	sed -e "s:(VDRINCDIR):(VDRDIR)/include:" -i Makefile || die

	# 787707
	eapply "${FILESDIR}/${P}_gcc11.patch"
}

src_install() {
	vdr-plugin-2_src_install

	insinto /usr/share/vdr/systeminfo/
	insopts -m0755
	doins "${FILESDIR}"/systeminfo.sh
}
