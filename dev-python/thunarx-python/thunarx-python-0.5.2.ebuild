# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit python-single-r1

DESCRIPTION="Python bindings for the Thunar file manager"
HOMEPAGE="https://goodies.xfce.org/projects/bindings/thunarx-python"
SRC_URI="https://archive.xfce.org/src/bindings/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.30:2
	>=x11-libs/gtk+-3.20:3
	>=xfce-base/thunar-1.7.0
	$(python_gen_cond_dep '
		>=dev-python/pygobject-3.20:3[${PYTHON_MULTI_USEDEP}]
	')"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
