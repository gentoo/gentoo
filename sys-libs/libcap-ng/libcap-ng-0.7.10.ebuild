# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7,8}} )

inherit autotools flag-o-matic python-r1

DESCRIPTION="POSIX 1003.1e capabilities"
HOMEPAGE="https://people.redhat.com/sgrubb/libcap-ng/"
SRC_URI="https://people.redhat.com/sgrubb/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~x86-linux"
IUSE="python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	python? ( >=dev-lang/swig-2 )"

src_prepare() {
	default
	if use prefix ; then
		sed -i "s@cat /usr@cat ${EPREFIX}/usr@" bindings/python*/Makefile.am || die
		eautomake #668722
	fi
}

src_configure() {
	use sparc && replace-flags -O? -O0

	local ECONF_SOURCE="${S}"

	local myconf=(
		$(use_enable static-libs static)
	)

	local pythonconf=( --without-python --without-python3 )

	# set up python bindings build(s)
	if use python ; then
		setup_python_flags_configure() {
			if python_is_python3; then
				pythonconf=( --without-python --with-python3 )
			else
				pythonconf=( --with-python --without-python3 )
				local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
			fi
			run_in_build_dir econf "${pythonconf[@]}" "${myconf[@]}"
		}

		python_foreach_impl setup_python_flags_configure
	else
		local BUILD_DIR=${WORKDIR}/build
		run_in_build_dir econf "${pythonconf[@]}" "${myconf[@]}"
	fi
}

src_compile() {
	if use python; then
		python_foreach_impl run_in_build_dir emake
	else
		local BUILD_DIR=${WORKDIR}/build
		emake -C "${BUILD_DIR}"
	fi
}

src_test() {
	if [[ "${EUID}" -eq 0 ]]; then
		ewarn "Skipping tests due to root permissions."
		return
	fi

	if use python; then
		python_foreach_impl run_in_build_dir emake check
	else
		local BUILD_DIR=${WORKDIR}/build
		emake -C "${BUILD_DIR}" check
	fi
}

src_install() {
	if use python; then
		python_foreach_impl run_in_build_dir emake DESTDIR="${D}" install
	else
		local BUILD_DIR=${WORKDIR}/build
		emake -C "${BUILD_DIR}" DESTDIR="${D}" install
	fi
	find "${ED}" -name '*.la' -delete || die
}
