# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: enable/disable parentalrating in records"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-pin/"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-pin/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-pin-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr[pinplugin]"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i "s:INCLUDES += -I\$(VDRINCDIR):INCLUDES += -I\$(VDRDIR)/include:" Makefile || die "sed failed"

	# respect LDFLAGS, bug 770172
	sed -i "s:\$(CXXFLAGS) \$(CMDOBJS):\$(CXXFLAGS) \$(LDFLAGS) \$(CMDOBJS):" Makefile || die "sed failed"
}

src_install() {
	vdr-plugin-2_src_install

	dobin fskcheck

	insinto /usr/share/vdr/plugins/${VDRPLUGIN}
	doins "${S}"/scripts/fskprotect.sh

	insinto /usr/share/vdr/record
	newins "${S}"/scripts/cut.sh 20-preserve-pin-after-cut.sh

	insinto /etc/vdr/reccmds
	doins "${FILESDIR}"/reccmds.pin.conf
}
