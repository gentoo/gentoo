# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 xdg

DESCRIPTION="PyQt5-based launcher for FS-UAE"
HOMEPAGE="https://fs-uae.net/"
SRC_URI="https://fs-uae.net/stable/${PV}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="lha"

RDEPEND="
	app-emulation/fs-uae
	$(python_gen_cond_dep '
		dev-python/PyQt5[${PYTHON_MULTI_USEDEP},declarative,gui,network,opengl,widgets]
		dev-python/pyopengl[${PYTHON_MULTI_USEDEP}]
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
		lha? ( dev-python/python-lhafile[${PYTHON_MULTI_USEDEP}] )
	')
"

BDEPEND="
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.0-ROMs.patch
)

src_prepare() {
	default

	# Unbundle OpenGL library. Keep oyoyo IRC library because upstream
	# is long dead and it's not worth packaging separately.
	rm -r OpenGL/ || die
	sed -i -r "/OpenGL/d" setup.py || die
}

python_compile_all() {
	emake
}

python_install() {
	local dir=${EPREFIX}/usr/share/${PN}
	distutils-r1_python_install --install-lib="${dir}" --install-scripts="${dir}"
}

python_install_all() {
	dosym ../share/${PN}/${PN} /usr/bin/${PN}
	emake install-data DESTDIR="${D}" prefix="${EPREFIX}"/usr
	mv "${ED}"/usr/share/doc/{${PN},${PF}} || die
}

pkg_postinst() {
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
