# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

VERSION_GIT="9f8fb2260b73971d69691962df472c992d94b123"

DESCRIPTION="VDR plugin: enable/disable parentalrating in records"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-pin"
SRC_URI="https://projects.vdr-developer.org/git/vdr-plugin-pin.git/snapshot/vdr-plugin-pin-${VERSION_GIT}.tar.bz2"
KEYWORDS="~amd64 ~x86"

SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="media-video/vdr[pinplugin]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/vdr-plugin-pin-${VERSION_GIT}"

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
