# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=mozart2-stdlib
inherit cmake

PATCHSET_VER="0"

DESCRIPTION="The Mozart Standard Library"
HOMEPAGE="http://mozart2.org/"
SRC_URI="https://dev.gentoo.org/~keri/distfiles/mozart-stdlib/${MY_PN}-${PV}.tar.gz
	https://dev.gentoo.org/~keri/distfiles/mozart-stdlib/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"

LICENSE="Mozart"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/mozart-2.0.1"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	if [[ -d "${WORKDIR}"/${PV} ]] ; then
		eapply "${WORKDIR}"/${PV}
	fi
	cmake_src_prepare
}
