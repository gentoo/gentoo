# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Keep an eye on Fedora's packaging (https://src.fedoraproject.org/rpms/libcap-ng/tree/rawhide) for patches
# Same maintainer in Fedora as upstream
PYTHON_COMPAT=( python3_{8..10} )
inherit autotools flag-o-matic python-r1

DESCRIPTION="POSIX 1003.1e capabilities"
HOMEPAGE="https://people.redhat.com/sgrubb/libcap-ng/"
# Patch works around / reverts a behaviour change because not all consumers were ready.
# Keep this patch for a bit longer until Fedora stop shipping it (not clear what else
# other than gnome-keyring was broken by it: bug #759550)
# Fedora 0.8.2 https://src.fedoraproject.org/rpms/libcap-ng/c/a5b0f536df1132d8e7afa4c0ce07b630e7970cad?branch=master
SRC_URI="https://people.redhat.com/sgrubb/${PN}/${P}.tar.gz
	https://src.fedoraproject.org/rpms/libcap-ng/raw/a5b0f536df1132d8e7afa4c0ce07b630e7970cad/f/libcap-ng-0.8.2-apply-disable.patch"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x86-linux"
IUSE="python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers"
BDEPEND="python? ( >=dev-lang/swig-2 )"

PATCHES=(
	"${DISTDIR}"/libcap-ng-0.8.2-apply-disable.patch
)

src_prepare() {
	default

	if use prefix ; then
		sed -i "s@cat /usr@cat ${EPREFIX}/usr@" bindings/python*/Makefile.am || die
		# bug #668722
		eautomake
	fi
}

src_configure() {
	use sparc && replace-flags -O? -O0

	local ECONF_SOURCE="${S}"

	local myconf=(
		$(use_enable static-libs static)
	)

	local pythonconf=(
		--without-python
		--without-python3
	)

	# Set up python bindings build(s)
	if use python ; then
		setup_python_flags_configure() {
			pythonconf=(
				--without-python
				--with-python3
			)

			run_in_build_dir econf "${pythonconf[@]}" "${myconf[@]}"
		}

		python_foreach_impl setup_python_flags_configure
	else
		local BUILD_DIR="${WORKDIR}"/build
		run_in_build_dir econf "${pythonconf[@]}" "${myconf[@]}"
	fi
}

src_compile() {
	if use python ; then
		python_foreach_impl run_in_build_dir emake
	else
		local BUILD_DIR="${WORKDIR}"/build
		emake -C "${BUILD_DIR}"
	fi
}

src_test() {
	if [[ "${EUID}" -eq 0 ]] ; then
		ewarn "Skipping tests due to root permissions."
		return
	fi

	if use python ; then
		python_foreach_impl run_in_build_dir emake check
	else
		local BUILD_DIR="${WORKDIR}"/build
		emake -C "${BUILD_DIR}" check
	fi
}

src_install() {
	if use python ; then
		python_foreach_impl run_in_build_dir emake DESTDIR="${D}" install
	else
		local BUILD_DIR="${WORKDIR}"/build
		emake -C "${BUILD_DIR}" DESTDIR="${D}" install
	fi

	find "${ED}" -name '*.la' -delete || die
}
