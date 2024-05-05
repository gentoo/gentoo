# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit bash-completion-r1 autotools python-single-r1 optfeature

DESCRIPTION="Yet more Objects for (High Energy Physics) Data Analysis"
HOMEPAGE="https://yoda.hepforge.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/hepcedar/yoda"
else
	COMMIT="d70c8f9884633fcb32f40b80929c7f1006ea3386"
	SRC_URI="https://gitlab.com/hepcedar/${PN}/-/archive/${COMMIT}/${PN}-${COMMIT}.tar.bz2"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0/${PV}"
IUSE="root test +python +zlib"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} ) root? ( python )"

RDEPEND="
	root? ( sci-physics/root:=[${PYTHON_SINGLE_USEDEP}] )
	python? ( ${PYTHON_DEPS} )
	zlib? ( sys-libs/zlib )
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

PATCHES=(
	# https://gitlab.com/hepcedar/yoda/-/merge_requests/212
	"${FILESDIR}/${PN}-2.0.0-bash_completion.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	# reconf due to python3_10 patch
	eautoreconf
}

src_configure() {
	# we need to use the prefix cython here
	econf --disable-static \
		$(use_enable root) \
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
		bashcomp_alias ${PN}-config ${PN}stack \
			${PN}diff \
			${PN}cnv \
			${PN}scale \
			${PN}2root \
			${PN}merge \
			${PN}plot \
			${PN}ls \
			${PN}envelope \

		rm "${ED}"/etc/bash_completion.d/${PN}-completion || die
	fi

	use python && python_optimize
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	optfeature "plotting support" virtual/latex-base dev-python/matplotlib
}
