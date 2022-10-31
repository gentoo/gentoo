# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 gnome2-utils xdg

DESCRIPTION="GUI test tool and automation framework using accessibility framework"
HOMEPAGE="https://gitlab.com/dogtail/dogtail"
SRC_URI="https://gitlab.com/${PN}/${PN}/raw/released/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE=""

RDEPEND="
	dev-libs/gobject-introspection
	dev-python/pyatspi[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/libwnck:3[introspection]
	x11-base/xorg-server[xvfb]
	x11-apps/xinit
"
DEPEND=""
BDEPEND=""

# Tests require org.gnome.desktop.interface toolkit-accessibility
#distutils_enable_tests nose

src_prepare() {
	# Install docs in one place
	sed "s:doc/${PN}:doc/${PF}:" -i setup.py || die

	# Upstream loads resources relative to __file__, which doesn't work with
	# gentoo's dev-lang/python-exec. So we need to add hard-coded paths.
	eapply "${FILESDIR}"/${PN}-0.9.10-gentoo-paths.patch
	sed -e "s:@EPREFIX_USR@:'${EPREFIX}/usr':" -i sniff/sniff || die "sed failed"

	xdg_src_prepare
	distutils-r1_src_prepare
}
