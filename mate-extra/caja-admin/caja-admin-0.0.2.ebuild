# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/infirit/caja-admin"
elif [[ ${PV} =~ _p[0-9]{8,} ]]; then
	SHA="0af109ac79df76fbcc406d577d79f1c64d1a1fca"
	SRC_URI="https://github.com/infirit/${PN}/archive/${SHA}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${SHA}"
else
	SRC_URI="https://github.com/infirit/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

CMAKE_MIN_VERSION="2.6"
PYTHON_COMPAT=( python{2_7,3_6,3_7,3_8} )

inherit cmake-utils python-single-r1

DESCRIPTION="Caja Admin Extension"
HOMEPAGE="https://github.com/infirit/caja-admin"

LICENSE="GPL-3+"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}"
RDEPEND="${COMMON_DEPEND}
	app-editors/pluma
	dev-python/python-caja[${PYTHON_SINGLE_USEDEP}]
	sys-auth/polkit
	x11-terms/mate-terminal
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
"
BDEPEND=""

src_install() {
	cmake-utils_src_install
	python_optimize "${D}/usr/share/caja-python/extensions"
}
