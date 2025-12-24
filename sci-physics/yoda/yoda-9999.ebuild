# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit bash-completion-r1 python-single-r1 optfeature autotools

DESCRIPTION="Yet more Objects for (High Energy Physics) Data Analysis"
HOMEPAGE="https://yoda.hepforge.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/hepcedar/yoda"
	EGIT_BRANCH="main"
else
	SRC_URI="https://yoda.hepforge.org/downloads?f=${P^^}.tar.bz2 -> ${P^^}.tar.bz2"
	S="${WORKDIR}/${P^^}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0/${PV}"
IUSE="test +eigen +highfive +python +zlib"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-cpp/yaml-cpp
	eigen? ( dev-cpp/eigen:3= )
	highfive? (
		sci-libs/highfive
		sci-libs/hdf5[cxx]
	)
	python? ( ${PYTHON_DEPS} )
	zlib? ( virtual/zlib:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	python? (
		$(python_gen_cond_dep '
			>=dev-python/cython-0.29.24[${PYTHON_USEDEP}]
		')
		test? (
			$(python_gen_cond_dep '
				dev-python/numpy[${PYTHON_USEDEP}]
				dev-python/matplotlib[${PYTHON_USEDEP}]
			')
		)
	)
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	# reconf due to 9999 version
	eautoreconf
}

src_configure() {
	# we need to use the prefix cython here
	econf --disable-static \
		--with-yaml-cpp="${EPREFIX}/usr" \
		$(use_with eigen eigen "${EPREFIX}/usr/include/eigen3") \
		$(use_enable highfive h5) \
		$(use_with highfive highfive "${ESYSROOT}/usr") \
		$(use_enable python pyext) \
		$(use_with zlib zlib "${ESYSROOT}/usr") \
		$(usex python CYTHON="${ESYSROOT}/usr/bin/cython")
}

src_test() {
	# PYTESTS and SHTESTS both require python tools
	if use python; then
		emake check
	else
		emake check PYTESTS= SHTESTS= NO_PYTHON=1
	fi
}

src_install() {
	default

	if use python ; then
		newbashcomp "${ED}"/etc/bash_completion.d/${PN}-completion ${PN}-config
		bashcomp_alias ${PN}-config \
			${PN}ls \
			${PN}diff \
			${PN}merge \
			${PN}stack \
			${PN}scale \
			${PN}plot \
			${PN}envelope \
			${PN}cnv \
			${PN}2root
		rm "${ED}"/etc/bash_completion.d/${PN}-completion || die
		python_optimize
	fi

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	optfeature "root conversion" sci-physics/root
	optfeature "latex plotting support" virtual/latex-base
	optfeature "python plotting support" dev-python/matplotlib
}
