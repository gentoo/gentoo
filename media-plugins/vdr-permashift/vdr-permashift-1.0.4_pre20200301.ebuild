# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

# commit 2020/03/01
GIT_VERSION="f3541d7c0e3e201daf06a49304db0a0d7d5f8dd1"

DESCRIPTION="VDR Plugin: permanent timeshift by recording live TV on RAM"
HOMEPAGE="https://ein-eike.de/vdr-plugin-permashift-english/"
SRC_URI="https://github.com/eikesauer/Permashift/archive/${GIT_VERSION}.tar.gz -> ${PF}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="|| ( ~media-video/vdr-2.2.0[permashift]
	>=media-video/vdr-2.4.1-r3[permashift]
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Permashift-${GIT_VERSION}"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"
