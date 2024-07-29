# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="razerCommander"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python3_{11..12} )

inherit meson python-single-r1 xdg

DESCRIPTION="GTK contol center for managing Razer peripherals on Linux"
HOMEPAGE="https://gitlab.com/gabmus/razerCommander/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.com/gabmus/${MY_PN}.git"
else
	SRC_URI="https://gitlab.com/gabmus/${MY_PN}/-/archive/${PV}/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=x11-libs/gtk+-3.20:3[introspection]
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		sys-apps/openrazer[client,daemon,${PYTHON_USEDEP}]
	')
"
BDEPEND="
	${RDEPEND}
"

src_install() {
	meson_src_install
	python_optimize
}
