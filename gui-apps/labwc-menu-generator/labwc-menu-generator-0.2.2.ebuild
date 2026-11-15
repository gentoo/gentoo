# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Simple, lightweight, Labwc/Openbox XML-menu generator"
HOMEPAGE="https://github.com/labwc/labwc-menu-generator"

if [[ $PV = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI=https://github.com/labwc/labwc-menu-generator
else
	SRC_URI="https://github.com/labwc/labwc-menu-generator/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	app-text/scdoc
	dev-libs/glib:2
"
RDEPEND="${DEPEND}"

# The tests assume this
BUILD_DIR="${S}/build"

src_install() {
	meson_src_install

	docinto contrib/
	dodoc contrib/*
}
