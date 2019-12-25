# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

GIT_COMMIT="19e3057f34d9c097c8c6bad30188b14d80b7a242"
MY_P="vdr-plugin-satip-${GIT_COMMIT}"

DESCRIPTION="VDR Plugin: integrates SAT>IP network devices seamlessly into VDR"
HOMEPAGE="http://www.saunalahti.fi/~rahrenbe/vdr/satip/"
SRC_URI="https://github.com/rofafor/vdr-plugin-satip/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND=">=media-video/vdr-2.4.0
		>=net-misc/curl-7.36
		|| ( dev-libs/pugixml
		dev-libs/tinyxml )"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-satip.*
	usr/lib64/vdr/plugins/libvdr-satip.*"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	vdr-plugin-2_src_prepare

	if has_version "dev-libs/tinyxml" ; then
		sed -e "s:#SATIP_USE_TINYXML:SATIP_USE_TINYXML:" -i Makefile || die "sed failed"
	fi
}
