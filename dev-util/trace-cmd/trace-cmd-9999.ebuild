# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_OPTIONAL=1

inherit linux-info python-r1 toolchain-funcs

DESCRIPTION="User-space front-end for Ftrace"
HOMEPAGE="https://trace-cmd.org/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git"
	inherit git-r3
else
	SRC_URI="https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/snapshot/${PN}-v${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-v${PV}"
fi

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/${PV}"
IUSE="+audit doc python udis86"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="audit? ( sys-process/audit )
	python? ( ${PYTHON_DEPS} )
	udis86? ( dev-libs/udis86 )"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	python? (
		virtual/pkgconfig
		dev-lang/swig
	)
	doc? ( app-text/asciidoc )"

CONFIG_CHECK="
	~TRACING
	~FTRACE
	~BLK_DEV_IO_TRACE"

pkg_setup() {
	linux-info_pkg_setup
}

src_configure() {
	EMAKE_FLAGS=(
		BUILD_OUTPUT="${WORKDIR}/${P}_build"
		"prefix=${EPREFIX}/usr"
		"libdir=${EPREFIX}/usr/$(get_libdir)"
		"CC=$(tc-getCC)"
		"AR=$(tc-getAR)"
		$(usex audit '' '' '' 'NO_AUDIT=1')
		$(usex udis86 '' '' '' 'NO_UDIS86=1')
		VERBOSE=1
	)
}

src_compile() {
	emake "${EMAKE_FLAGS[@]}" NO_PYTHON=1 \
		trace-cmd

	if use python; then
		python_copy_sources
		python_foreach_impl python_compile
	fi

	use doc && emake doc
}

python_compile() {
	pushd "${BUILD_DIR}" > /dev/null || die

	emake "${EMAKE_FLAGS[@]}" \
		PYTHON_VERS="${EPYTHON}" \
		PYTHON_PKGCONFIG_VERS="${EPYTHON//python/python-}" \
		python_dir=$(python_get_sitedir)/${PN} \
		python python-plugin

	popd > /dev/null || die
}

src_install() {
	emake "${EMAKE_FLAGS[@]}" NO_PYTHON=1 \
		DESTDIR="${D}" \
		install install_libs

	use doc && emake DESTDIR="${D}" install_doc
	use python && python_foreach_impl python_install
}

python_install() {
	pushd "${BUILD_DIR}" > /dev/null || die

	emake "${EMAKE_FLAGS[@]}" DESTDIR="${D}" \
		PYTHON_VERS="${EPYTHON}" \
		PYTHON_PKGCONFIG_VERS="${EPYTHON//python/python-}" \
		python_dir=$(python_get_sitedir)/${PN} \
		install_python

	popd > /dev/null || die
}
