# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/infirit/caja-admin"
else
	SRC_URI="https://github.com/infirit/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

PYTHON_COMPAT=( python3_{11..13} )

inherit meson python-single-r1

DESCRIPTION="Caja Admin Extension"
HOMEPAGE="https://github.com/infirit/caja-admin"

LICENSE="GPL-3+"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}"
RDEPEND="${COMMON_DEPEND}
	app-editors/pluma
	dev-python/python-caja[${PYTHON_SINGLE_USEDEP}]
	sys-auth/polkit
	x11-terms/mate-terminal
"
BDEPEND="${COMMON_DEPEND}
	sys-devel/gettext
"

src_install() {
	meson_src_install
	python_optimize "${D}/usr/share/caja-python/extensions"
}
