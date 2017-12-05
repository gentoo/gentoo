# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Python bindings for the Thunar file manager"
HOMEPAGE="https://goodies.xfce.org/projects/bindings/thunarx-python"
SRC_URI="mirror://xfce/src/bindings/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	>=x11-libs/gtk+-3.20:3
	>=dev-libs/glib-2.30:2
	>=dev-python/pygobject-3.20:3[${PYTHON_USEDEP}]
	>=xfce-base/thunar-1.7.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DOCS=( AUTHORS ChangeLog NEWS README )

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
