# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A simple, easily embeddable cross-platform C library"
HOMEPAGE="https://github.com/dcreager/libcork"
SRC_URI="https://github.com/dcreager/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND="dev-libs/check"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	if ! [ -e "${S}"/RELEASE-VERSION ] ; then
		echo ${PV} > "${S}"/RELEASE-VERSION || die
	fi
	eapply "${FILESDIR}"/${P}-git.patch
	eapply "${FILESDIR}"/${P}-version.patch

	cmake-utils_src_prepare
}

src_install() {
	cmake-utils_src_install
}
