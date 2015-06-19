# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-recstatus/vdr-recstatus-0.0.8.ebuild,v 1.4 2014/08/10 21:06:47 slyfox Exp $

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: displays the recording status of the available devices"
HOMEPAGE="http://www.constabel.net/projects/recstatus/wiki"
SRC_URI="https://www.constabel.net/files/vdr/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.5.7"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	if has_version ">=media-video/vdr-1.7.28"; then
		sed -i "s:SetRecording(\([^,]*\),[^)]*)):SetRecording(\1\):" recstatus.c
	fi
}
