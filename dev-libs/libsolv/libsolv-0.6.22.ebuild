# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
USE_RUBY=( ruby23 )
RUBY_OPTIONAL=yes

inherit cmake-utils python-r1 ruby-ng perl-module multilib

DESCRIPTION="Library for solving packages and reading repositories"
HOMEPAGE="http://doc.opensuse.org/projects/libzypp/HEAD/ https://github.com/openSUSE/libsolv"
SRC_URI="https://github.com/openSUSE/libsolv/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="bzip2 lzma perl python rpm ruby tcl"

RDEPEND="
	dev-libs/expat
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	rpm? ( app-arch/rpm )
	ruby? ( $(ruby_implementations_depend) )
	tcl? ( dev-lang/tcl:0= )"
DEPEND="${RDEPEND}
	perl? ( dev-lang/swig:0 )
	python? ( dev-lang/swig:0 )
	ruby? ( dev-lang/swig:0 )
	tcl? ( dev-lang/swig:0 )
	sys-devel/gettext"

# The ruby-ng eclass is stupid and breaks this for no good reason.
S="${WORKDIR}/${P}"

pkg_setup() {
	use perl && perl_set_version
	use ruby && ruby-ng_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	# The python bindings are tightly integrated w/cmake.
	sed -i \
		-e 's: libsolv: -lsolv:g' \
		bindings/python/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_VENDORDIRS=1
		-DLIB="$(get_libdir)"
		-DENABLE_PYTHON=0
		$(cmake-utils_use_enable bzip2 BZIP2_COMPRESSION)
		$(cmake-utils_use_enable lzma LZMA_COMPRESSION)
		$(cmake-utils_use_enable perl PERL)
		$(cmake-utils_use_enable rpm RPMDB)
		$(cmake-utils_use_enable rpm RPMMD)
		$(cmake-utils_use_enable ruby RUBY)
		$(cmake-utils_use_enable tcl TCL)
	)

	cmake-utils_src_configure

	if use python ; then
		# python_foreach_impl will create a unique BUILD_DIR for
		# us to run inside of, so no need to manage it ourselves.
		mycmakeargs+=(
			# Rework the bindings for a minor configure speedup.
			-DENABLE_PYTHON=1
			-DENABLE_{PERL,RUBY,TCL}=0
		)
		# Link against the common library so the bindings don't
		# have to rebuild it.
		LDFLAGS="-L${BUILD_DIR}/src ${LDFLAGS}" \
		python_foreach_impl cmake-utils_src_configure
	fi
}

pysolv_phase_func() {
	BUILD_DIR="${BUILD_DIR}/bindings/python" \
	cmake-utils_${EBUILD_PHASE_FUNC}
}

src_compile() {
	cmake-utils_src_compile

	use python && python_foreach_impl pysolv_phase_func
}

src_install() {
	cmake-utils_src_install

	use python && python_foreach_impl pysolv_phase_func
	use perl && perl_delete_localpod
}
