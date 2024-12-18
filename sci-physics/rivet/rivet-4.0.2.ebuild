# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )

inherit python-single-r1 flag-o-matic autotools optfeature bash-completion-r1

MY_PN="Rivet"
MY_PF=${MY_PN}-${PV}

DESCRIPTION="Rivet toolkit (Robust Independent Validation of Experiment and Theory)"
HOMEPAGE="
	https://rivet.hepforge.org/
	https://gitlab.com/hepcedar/rivet
"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/hepcedar/rivet"
else
	SRC_URI="https://www.hepforge.org/archive/rivet/${MY_PF}.tar.gz -> ${P}.tar.gz"
	S=${WORKDIR}/${MY_PF}
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="4"
IUSE="+zlib +python +highfive"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	>=sci-physics/fastjet-3.4.0[plugins]
	>=sci-physics/fastjet-contrib-1.048
	>=sci-physics/hepmc-3.1.1:3=[-cm(-),gev(+)]
	highfive? (
		sci-libs/HighFive
		sci-libs/hdf5[cxx]
	)

	sci-libs/gsl
	zlib? ( sys-libs/zlib )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/matplotlib[${PYTHON_USEDEP}]
		')
		>=sci-physics/yoda-2[${PYTHON_SINGLE_USEDEP}]
	)
	!python? (
		>=sci-physics/yoda-2
	)
	!sci-physics/rivet:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-shells/bash
	python? (
		$(python_gen_cond_dep '
			>=dev-python/cython-0.29.24[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.6-binreloc.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Eigen complains about alignment (see https://gitlab.com/libeigen/eigen/-/issues/2523).
	# does this affect more cpus?
	replace-cpu-flags znver1 x86-64
	# not posix compatible, only bash
	CONFIG_SHELL=${ESYSROOT}/bin/bash econf \
		$(use_with zlib zlib "${ESYSROOT}/usr") \
		--with-hepmc3="${ESYSROOT}/usr" \
		$(usex highfive "--with-highfive=${ESYSROOT}/usr" "") \
		--with-yoda="${ESYSROOT}/usr" \
		--with-fastjet="${ESYSROOT}/usr" \
		$(use_enable python pyext) \
		$(usex python CYTHON="${ESYSROOT}/usr/bin/cython")
}

src_install() {
	default
	use python && python_optimize
	find "${ED}" -name '*.la' -delete || die
	if use python ; then
		newbashcomp "${ED}"/etc/bash_completion.d/${PN}-completion ${PN}
		bashcomp_alias ${PN} \
			${PN}-config \
			${PN}-build \
			${PN}-cmphistos \
			make-plots \
			${PN}-mkhtml-tex \
			${PN}-mkhtml
		rm "${ED}"/etc/bash_completion.d/${PN}-completion || die
	fi
}

pkg_postinstall() {
	optfeature "latex plotting support" virtual/latex-base media-gfx/imagemagick app-text/ghostscript-gpl
	optfeature "python plotting support" dev-python/matplotlib
}
