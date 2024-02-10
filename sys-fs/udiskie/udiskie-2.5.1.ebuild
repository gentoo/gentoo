# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi xdg-utils

DESCRIPTION="An automatic disk mounting service using udisks"
HOMEPAGE="https://pypi.org/project/udiskie/ https://github.com/coldfix/udiskie"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="libnotify"

RDEPEND="dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	sys-fs/udisks:2
	libnotify? ( x11-libs/libnotify[introspection] )"
DEPEND="app-text/asciidoc
	test? ( dev-python/keyutils[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:gtk-update-icon-cache:true:' setup.py || die
	sed -i -e 's: HACKING.rst, TRANSLATIONS.rst,::'	setup.cfg || die
	default

	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
	emake -C doc
}

src_install() {
	distutils-r1_src_install
	doman doc/${PN}.8
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
