# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
inherit gnome.org meson python-any-r1

DESCRIPTION="GWeather Locations Database"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gweather-locations"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

BDEPEND="
	$(python_gen_any_dep '
		dev-python/pygobject[${PYTHON_USEDEP}]
	')
	virtual/pkgconfig
"

python_check_deps() {
	python_has_version "dev-python/pygobject[${PYTHON_USEDEP}]"
}

src_test() {
	meson_src_test --no-suite lint
}
