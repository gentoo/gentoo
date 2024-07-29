# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=yes

inherit distutils-r1 xdg

DESCRIPTION="PyQt5-based launcher for FS-UAE"
HOMEPAGE="https://fs-uae.net/"
SRC_URI="https://fs-uae.net/files/FS-UAE-Launcher/Stable/${PV}/${P}.tar.xz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="lha"
RESTRICT="test" # The test files are just boilerplate.

RDEPEND="
	app-emulation/fs-uae
	$(python_gen_cond_dep '
		dev-python/PyQt5[${PYTHON_USEDEP},declarative,gui,network,opengl,widgets]
		dev-python/pyopengl[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		lha? ( dev-python/python-lhafile[${PYTHON_USEDEP}] )
	')
"

BDEPEND="
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.0-ROMs.patch
)

python_compile_all() {
	emake mo
}

python_install_all() {
	emake install-data DESTDIR="${D}" prefix="${EPREFIX}"/usr
	mv "${ED}"/usr/share/doc/{${PN},${PF}} || die
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Some important information:"
	elog
	ewarn " - Do not use QtCurve, it will crash PyQt5!"
	elog
	elog " - By default, FS-UAE creates its directories under Documents/FS-UAE."
	elog "   If your Documents directory is not configured according to the XDG"
	elog "   user diretory spec, ~/FS-UAE will be used as a fallback."
	elog
	elog " - You can override this by putting the path to the desired base"
	elog "   directory in a special config file. The config file will be read"
	elog "   from ~/.config/fs-uae/base-dir by both FS-UAE and FS-UAE Launcher"
	elog "   if it exists."
	elog
	elog "   Alternatively, you can start FS-UAE and/or FS-UAE Launcher with"
	elog "   --base-dir=/path/to/desired/dir"
}
