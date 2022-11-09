# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_OPTIONAL=1

inherit linux-info bash-completion-r1 python-r1 toolchain-funcs

DESCRIPTION="User-space front-end for Ftrace"
HOMEPAGE="https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/trace-cmd/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/snapshot/${PN}-v${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
	S="${WORKDIR}/${PN}-v${PV}"
fi

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/${PV}"
IUSE="+audit doc python test udis86 +zstd"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

# XXX trace-cmd autodetects this without configurability. This might cause
# issues if the libraries are picked up with the useflag disabled and later
# uninstalled
RDEPEND="
	audit? ( sys-process/audit )
	python? ( ${PYTHON_DEPS} )
	udis86? ( dev-libs/udis86 )
	zstd? ( >=app-arch/zstd-1.4 )
	>=dev-libs/libtracefs-1.4
	>=dev-libs/libtraceevent-1.5
"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	test? ( dev-util/cunit )
"
BDEPEND="
	virtual/pkgconfig
	python? ( dev-lang/swig )
	doc? ( app-text/asciidoc )
"

# having trouble getting tests to compile
RESTRICT+=" test"

pkg_setup() {
	local CONFIG_CHECK="
		~TRACING
		~FTRACE
		~BLK_DEV_IO_TRACE"

	linux-info_pkg_setup
}

src_prepare() {
	default
	sed -r -e 's:([[:space:]]+)install_bash_completion($|[[:space:]]+):\1:' \
		-i Makefile || die "sed failed"
}

src_configure() {
	EMAKE_FLAGS=(
		BUILD_OUTPUT="${WORKDIR}/${P}_build"
		"prefix=${EPREFIX}/usr"
		"libdir=${EPREFIX}/usr/$(get_libdir)"
		"CC=$(tc-getCC)"
		"AR=$(tc-getAR)"
		"BASH_COMPLETE_DIR=$(get_bashcompdir)"
		"etcdir=/etc"
		$(usex audit '' 'NO_AUDIT=' '' '1')
		$(usex test 'CUNIT_INSTALLED=' '' '1' '')
		$(usex udis86 '' 'NO_UDIS86=' '' '1')
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
		python ctracecmd.so

	popd > /dev/null || die
}

src_test() {
	emake "${EMAKE_FLAGS[@]}" test
}

src_install() {
	emake "${EMAKE_FLAGS[@]}" NO_PYTHON=1 \
		DESTDIR="${D}" \
		install install_libs

	newbashcomp tracecmd/trace-cmd.bash "${PN}"

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

	python_optimize
}
