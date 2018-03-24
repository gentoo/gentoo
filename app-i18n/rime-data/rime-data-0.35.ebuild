# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="brise"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Data resources for Rime Input Method Engine"
HOMEPAGE="http://rime.im/ https://github.com/rime/brise"
SRC_URI="https://dl.bintray.com/lotem/rime/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND="app-i18n/librime"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"
