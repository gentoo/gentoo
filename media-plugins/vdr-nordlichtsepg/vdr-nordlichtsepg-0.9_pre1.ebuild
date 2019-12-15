# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

MY_P="${PN}-${PV/_pre/-test}"

DESCRIPTION="vdr Plugin: Better EPG view than default vdr"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://vdr.websitec.de/download/${PN}/${MY_P}.tgz"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

DEPEND="media-video/vdr"

S="${WORKDIR}/${PN#vdr-}-${PV%_pre*}"
