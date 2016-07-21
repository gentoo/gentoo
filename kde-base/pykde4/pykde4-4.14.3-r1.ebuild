# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="threads"
OPENGL_REQUIRED="always"
CMAKE_MAKEFILE_GENERATOR="emake"
inherit python-r1 portability kde4-base multilib eutils

DESCRIPTION="Python bindings for KDE4"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="akonadi debug doc examples test"
HOMEPAGE="https://techbase.kde.org/Development/Languages/Python"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/PyQt4-4.11.1[${PYTHON_USEDEP},dbus,declarative,script,sql,svg,webkit,X]
	>=dev-python/sip-4.16.2:=[${PYTHON_USEDEP}]
	$(add_kdebase_dep kdelibs 'opengl')
	akonadi? ( $(add_kdeapps_dep kdepimlibs) )
"
DEPEND="${RDEPEND}
	dev-lang/python-exec:2[${PYTHON_USEDEP}]
	sys-devel/libtool
"

PATCHES=( "${FILESDIR}/${P}-gcc-5.patch" )

pkg_setup() {
	kde4-base_pkg_setup

	have_python2=false

	scan_python_versions() {
		if [[ ${EPYTHON} == python2.* ]]; then
			have_python2=true
		fi
	}
	python_foreach_impl scan_python_versions

	if ! ${have_python2}; then
		ewarn "You do not have a Python 2 version selected."
		ewarn "kpythonpluginfactory will not be built"
	fi
}

src_prepare() {
	kde4-base_src_prepare

	if ! use examples; then
		sed -e '/^ADD_SUBDIRECTORY(examples)/s/^/# DISABLED /' -i CMakeLists.txt \
			|| die "Failed to disable examples"
	fi

	# See bug 322351
	use arm && epatch "${FILESDIR}/${PN}-4.14.0-arm-sip.patch"

	sed -e 's/kpythonpluginfactory /kpython${PYTHON_SHORT_VERSION}pluginfactory /g' \
		-i kpythonpluginfactory/CMakeLists.txt || die

	if ${have_python2}; then
		mkdir -p "${WORKDIR}/wrapper" || die "failed to copy wrapper"
		cp "${FILESDIR}/kpythonpluginfactorywrapper.c-r2" "${WORKDIR}/wrapper/kpythonpluginfactorywrapper.c" || die "failed to copy wrapper"
	fi
	python_copy_sources

}

src_configure() {
	configuration() {
		local mycmakeargs=(
			-DWITH_PolkitQt=OFF
			-DWITH_QScintilla=OFF
			-DPYKDEUIC4_ALTINSTALL=TRUE
			-DWITH_Nepomuk=OFF
			-DWITH_Soprano=OFF
			$(cmake-utils_use_with akonadi KdepimLibs)
			-DPYTHON_EXECUTABLE=${PYTHON}
		)
		local CMAKE_BUILD_DIR=${S}_build-${PYTHON_ABI}
		kde4-base_src_configure
	}

	python_foreach_impl run_in_build_dir configuration
}

echo_and_run() {
	echo "$@"
	"$@"
}

src_compile() {
	compilation() {
		local CMAKE_BUILD_DIR=${S}_build-${PYTHON_ABI}
		kde4-base_src_compile
	}
	python_foreach_impl run_in_build_dir compilation

	if ${have_python2}; then
		pushd "${WORKDIR}/wrapper" > /dev/null
		echo_and_run libtool --tag=CC --mode=compile $(tc-getCC) \
			-shared \
			${CFLAGS} ${CPPFLAGS} \
			-DEPREFIX="\"${EPREFIX}\"" \
			-DPLUGIN_DIR="\"/usr/$(get_libdir)/kde4\"" -c \
			-o kpythonpluginfactorywrapper.lo \
			kpythonpluginfactorywrapper.c
		echo_and_run libtool --tag=CC --mode=link $(tc-getCC) \
			-shared -module -avoid-version \
			${CFLAGS} ${LDFLAGS} \
			-o kpythonpluginfactory.la \
			-rpath "${EPREFIX}/usr/$(get_libdir)/kde4" \
			kpythonpluginfactorywrapper.lo \
			$(dlopen_lib)
		popd > /dev/null
	fi
}

src_test() {
	python_foreach_impl run_in_build_dir kde4-base_src_test
}

src_install() {
	installation() {
		emake DESTDIR="${D}" install

		mkdir -p "${D%/}$(python_get_scriptdir)" || die
		mv "${ED%/}/usr/bin/pykdeuic4-${EPYTHON/python/}" \
			"${D%/}$(python_get_scriptdir)"/pykdeuic4 || die

		python_fix_shebang "${D%/}$(python_get_scriptdir)"/pykdeuic4
		python_optimize
	}
	python_foreach_impl run_in_build_dir installation

	dosym ../lib/python-exec/python-exec2 /usr/bin/pykdeuic4

	# As we don't call the eclass's src_install, we have to install the docs manually
	DOCS=("${S}"/{AUTHORS,NEWS,README})
	use doc && HTML_DOCS=("${S}/docs/html/")
	einstalldocs

	if ${have_python2}; then
		pushd "${WORKDIR}/wrapper" > /dev/null
		echo_and_run libtool --mode=install install kpythonpluginfactory.la "${ED}/usr/$(get_libdir)/kde4/kpythonpluginfactory.la"
		rm "${ED}/usr/$(get_libdir)/kde4/kpythonpluginfactory.la"
		popd > /dev/null
	fi
}

pkg_postinst() {
	kde4-base_pkg_postinst

	if use examples; then
		echo
		elog "PyKDE4 examples have been installed to"
		elog "${EPREFIX}/usr/share/apps/${PN}/examples"
		echo
	fi
}
