# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: permanent timeshift by recording live TV on RAM"
HOMEPAGE="http://ein-eike.de/vdr-plugin-permashift-english/"
SRC_URI="http://ein-eike.de/wordpress/wp-content/uploads/2014/11/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-video/vdr-2.0.6[permashift]"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"
