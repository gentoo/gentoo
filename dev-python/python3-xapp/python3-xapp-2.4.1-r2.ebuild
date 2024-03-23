# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..12} )

inherit meson python-r1

DESCRIPTION="Python bindings for x11-libs/xapp"
HOMEPAGE="https://github.com/linuxmint/python3-xapp"
SRC_URI="https://github.com/linuxmint/python3-xapp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	$(python_gen_cond_dep '
		>=x11-libs/xapp-2.8.1[introspection,${PYTHON_USEDEP}]
	')
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	dev-python/psutil[${PYTHON_USEDEP}]
"

PATCHES=(
	# Make python installation configurable for distro packaging
	# https://github.com/linuxmint/python3-xapp/pull/23
	"${FILESDIR}"/${PN}-configurable-python-target.patch
)

src_configure() {
	configuring() {
		meson_src_configure \
			-Dpython_target="${EPYTHON}"
	}
	python_foreach_impl configuring
}

src_compile() {
	python_foreach_impl meson_src_compile
}

src_test() {
	python_foreach_impl meson_src_test
}

src_install() {
	installing() {
		meson_src_install
		python_optimize
	}
	python_foreach_impl installing
}
