# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit autotools multiprocessing python-r1

DESCRIPTION="Satyr is a collection of low-level algorithms for program failure processing"
HOMEPAGE="https://github.com/abrt/satyr"
SRC_URI="https://github.com/abrt/${PN}/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/4"

IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

KEYWORDS="amd64 x86"

RDEPEND="python? ( ${PYTHON_DEPS} )
	>=dev-libs/elfutils-0.158
	dev-libs/json-c:=
	dev-libs/nettle:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-util/gperf
"

src_prepare() {
	default
	./gen-version || die # Needs to be run before full autoreconf
	eautoreconf
	use python && python_copy_sources
}

src_configure() {
	use python && python_setup

	local myargs=(
		--localstatedir="${EPREFIX}/var"
		--without-rpm
		$(usex python "--with-python3" "--without-python3")
	)

	if use python; then
		python_configure() {
			econf "${myargs[@]}"
		}
		python_foreach_impl run_in_build_dir python_configure
	else
		econf "${myargs[@]}"
	fi
}

src_compile() {
	if use python; then
		python_foreach_impl run_in_build_dir default
	else
		default
	fi

}

src_test() {
	local extra_args

	# In order to pass --jobs to the test runner
	run_tests() {
		cd tests || die
		emake testsuite
		./testsuite --jobs=$(makeopts_jobs) ${extra_args[@]} $@

		# Only run the python bindings tests for other python impls
		extra_args=('-k' 'python3_bindings.*')
	}

	if use python; then
		python_foreach_impl run_in_build_dir run_tests
	else
		run_tests SKIP_PYTHON3=yes
	fi
}

src_install() {
	if use python; then
		python_install() {
			default
			python_optimize
		}
		python_foreach_impl run_in_build_dir python_install
	else
		default
	fi

	find "${D}" -name '*.la' -type f -delete || die
}
