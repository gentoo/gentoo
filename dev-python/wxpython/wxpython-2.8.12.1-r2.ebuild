# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
WX_GTK_VER="2.8"

inherit alternatives distutils-r1 eutils fdo-mime flag-o-matic wxwidgets

MY_P="${P/wxpython-/wxPython-src-}"

DESCRIPTION="A blending of the wxWindows C++ class library with Python"
HOMEPAGE="http://www.wxpython.org/"
SRC_URI="
	mirror://sourceforge/wxpython/${MY_P}.tar.bz2
	doc? (
		mirror://sourceforge/wxpython/wxPython-docs-${PV}.tar.bz2
		mirror://sourceforge/wxpython/wxPython-newdocs-2.8.9.2.tar.bz2 )
	examples? ( mirror://sourceforge/wxpython/wxPython-demo-${PV}.tar.bz2 )"

LICENSE="wxWinLL-3"
SLOT="2.8"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="cairo doc examples opengl"

RDEPEND="
	dev-lang/python-exec:2[${PYTHON_USEDEP}]
	>=x11-libs/wxGTK-${PV}:${WX_GTK_VER}[opengl?,tiff,X]
	dev-libs/glib:2
	dev-python/setuptools[${PYTHON_USEDEP}]
	media-libs/libpng:0=
	media-libs/tiff:0
	virtual/jpeg
	x11-libs/gtk+:2
	x11-libs/pango[X]
	cairo?	( >=dev-python/pycairo-1.8.4[${PYTHON_USEDEP}] )
	opengl?	( dev-python/pyopengl[${PYTHON_USEDEP}] )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}/wxPython"
DOC_S="${WORKDIR}/wxPython-${PV}"

# The hacky build system seems to be broken with out-of-source builds,
# and installs 'wx' package globally.
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	sed -i "s:cflags.append('-O3'):pass:" config.py || die "sed failed"

	if use doc; then
		cd "${DOC_S}" || die
		epatch "${FILESDIR}"/${PN}-${SLOT}-cache-writable.patch
	fi

	if use examples; then
		cd "${DOC_S}" || die
		epatch "${FILESDIR}"/${PN}-${SLOT}-wxversion-demo.patch
	fi

	cd "${S}" || die

	local PATCHES=(
		"${FILESDIR}"/${PN}-2.8.9-wxversion-scripts.patch
		# drop editra - we have it as a separate package now
		"${FILESDIR}"/${PN}-2.8.12-drop-editra.patch
		"${FILESDIR}"/${PN}-2.8.12-drop-categories.patch
		"${FILESDIR}"/${PN}-2.8-no-preservatives-added.patch
		# fix handling egg_info command
		"${FILESDIR}"/${PN}-2.8.12.1-disable-egging-mode.patch
	)

	distutils-r1_python_prepare_all
}

python_configure_all() {
	append-flags -fno-strict-aliasing
	# Workaround, buildsystem uses CFLAGS as CXXFLAGS
	export CFLAGS="${CXXFLAGS}"
	need-wxwidgets unicode

	mydistutilsargs=(
		WX_CONFIG="${WX_CONFIG}"
		WXPORT=gtk2
		UNICODE=1
		BUILD_GLCANVAS=$(usex opengl 1 0)
	)
}

python_compile() {
	# We need to have separate libdirs due to hackery, bug #455332.
	distutils-r1_python_compile \
		build --build-purelib "${BUILD_DIR}"/lib.common
}

python_install() {
	distutils-r1_python_install \
		build --build-purelib "${BUILD_DIR}"/lib.common

	# adjust the filenames for wxPython slots.
	local file
	for file in "${D}$(python_get_sitedir)"/wx{version.*,.pth}; do
		mv "${file}" "${file}-${SLOT}" || die
	done
	cd "${ED}"usr/lib/python-exec/"${EPYTHON}" || die
	for file in *; do
		mv "${file}" "${file}-${SLOT}" || die

		# wrappers are common to all impls, so a parallel run may
		# move it for us. ln+rm is more failure-proof.
		ln -fs ../lib/python-exec/python-exec2 "${ED}usr/bin/${file}-${SLOT}" || die
		rm -f "${ED}usr/bin/${file}"
	done
}

python_install_all() {
	dodoc docs/{CHANGES,PyManual,README,wxPackage,wxPythonManual}.txt

	domenu distrib/{Py{AlaMode,Crust,Shell},XRCed}.desktop
	newicon wx/py/PyCrust_32.png PyCrust.png
	newicon wx/tools/XRCed/XRCed_32.png XRCed.png

	docdir=${D}usr/share/doc/${PF}

	if use doc; then
		docinto docs
		dodoc -r "${DOC_S}"/docs/.
		# For some reason newer API docs aren't available so use 2.8.9.2's
		dodoc -r "${WORKDIR}"/wxPython-2.8.9.2/docs/.

		docompress -x /usr/share/doc/${PF}/docs
	fi

	if use examples; then
		docinto demo
		dodoc -r "${DOC_S}"/demo/.
		docinto samples
		dodoc -r "${DOC_S}"/samples/.

		[[ -e ${docdir}/samples/embedded/embedded ]] \
			&& rm -f "${docdir}"/samples/embedded/embedded

		docompress -x /usr/share/doc/${PF}/{demo,samples}
	fi
	distutils-r1_python_install_all
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	create_symlinks() {
		alternatives_auto_makesym "$(python_get_sitedir)/wx.pth" "$(python_get_sitedir)/wx.pth-[0-9].[0-9]"
		alternatives_auto_makesym "$(python_get_sitedir)/wxversion.py" "$(python_get_sitedir)/wxversion.py-[0-9].[0-9]"
	}
	python_foreach_impl create_symlinks

	echo
	elog "Gentoo uses the Multi-version method for SLOT'ing."
	elog "Developers, see this site for instructions on using"
	elog "2.6 or 2.8 with your apps:"
	elog "http://wiki.wxpython.org/index.cgi/MultiVersionInstalls"
	if use doc; then
		echo
		elog "To access the general wxWidgets documentation, run"
		elog "/usr/share/doc/${PF}/docs/viewdocs.py"
		echo
		elog "wxPython documentation is available by pointing a browser"
		elog "at /usr/share/doc/${PF}/docs/api/index.html"
	fi
	if use examples; then
		echo
		elog "The demo.py app which contains hundreds of demo modules"
		elog "with documentation and source code has been installed at"
		elog "/usr/share/doc/${PF}/demo/demo.py"
		echo
		elog "Many more example apps and modules can be found in"
		elog "/usr/share/doc/${PF}/samples/"
	fi
	echo
	elog "Editra is not packaged with wxpython in Gentoo."
	elog "You can find it in the tree as app-editors/editra"
}

pkg_postrm() {
	fdo-mime_desktop_database_update

	update_symlinks() {
		alternatives_auto_makesym "$(python_get_sitedir)/wx.pth" "$(python_get_sitedir)/wx.pth-[0-9].[0-9]"
		alternatives_auto_makesym "$(python_get_sitedir)/wxversion.py" "$(python_get_sitedir)/wxversion.py-[0-9].[0-9]"
	}
	python_foreach_impl update_symlinks
}
