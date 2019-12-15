# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: used to control the VDR Extension Board"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://vdr.websitec.de/download/${PN}/${P}.tar.gz
		http://vdr.websitec.de/download/${PN}/extb_firmware_1.08_lircd.conf.zip
		http://vdr.websitec.de/download/${PN}/extb.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-misc/lirc
		media-video/vdr"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i "${WORKDIR}"/extb/src/LinPIC/Makefile \
		-e "s:\$(LDLIBS):\$(LDFLAGS) \$(LDLIBS):"

	cd "${WORKDIR}"
	eapply -p0 "${FILESDIR}/${P}-gentoo.diff"
	eapply -p0 "${FILESDIR}/${P}_vdr-1.7.13.diff"
}

src_compile() {
	vdr-plugin-2_src_compile

	emake -C "${WORKDIR}/extb/src/LinPIC" all
}
src_install() {
	vdr-plugin-2_src_install

	dodoc README.de "${WORKDIR}/lircd.conf.extb_FW1.08"
	dodoc "${S}/wakeup/README.de"

	dobin "${WORKDIR}/extb/src/LinPIC/picdl"
	dobin "${WORKDIR}/extb/bin/extb.sh"
	dobin "${WORKDIR}/extb/bin/status.sh"
	dobin "${WORKDIR}/extb/bin/tx.sh"
	dobin "${S}/wakeup/extb-poweroff.pl"
	dobin "${S}/wakeup/examples/checkscript.sh"

	insinto /usr/share/extb/
	doins "${WORKDIR}/extb_1.08.hex"

	insinto /etc/extb
	doins "${WORKDIR}/extb/bin/PICflags.conf"
	doins "${S}/wakeup/examples/extb-poweroff.conf"
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	einfo "You need to upload the included firmware (1.08)"
	einfo "(you will find it in /usr/share/extb/)"
	einfo "into the extension board and update your lircd.conf"
	einfo "See the supplied lircd.conf.extb_FW1.08 in"
	einfo "/usr/share/doc/${PF}"
}
