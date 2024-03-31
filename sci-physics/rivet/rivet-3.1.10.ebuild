# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

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
SLOT="3"
IUSE="+hepmc3 hepmc2 +zlib +python"
REQUIRED_USE="
	^^ ( hepmc3 hepmc2 )
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	>=sci-physics/fastjet-3.4.0[plugins]
	>=sci-physics/fastjet-contrib-1.048
	hepmc2? ( sci-physics/hepmc:2=[-cm(-),gev(+)] )
	hepmc3? ( sci-physics/hepmc:3=[-cm(-),gev(+)] )

	sci-libs/gsl
	zlib? ( sys-libs/zlib )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/matplotlib[${PYTHON_USEDEP}]
		')
		>=sci-physics/yoda-1.9.8[${PYTHON_SINGLE_USEDEP}]
		<sci-physics/yoda-2[${PYTHON_SINGLE_USEDEP}]
	)
	!python? (
		>=sci-physics/yoda-1.9.8
		<sci-physics/yoda-2
	)
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
	"${FILESDIR}"/${PN}-3.1.9-pythontests.patch
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
		$(usex hepmc2 "--with-hepmc=${ESYSROOT}/usr" "") \
		$(usex hepmc3 "--with-hepmc3=${ESYSROOT}/usr" "") \
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
		bashcomp_alias ${PN} ${PN}-config \
			${PN}-build \
			${PN}-buildplugin \
			${PN}-cmphistos \
			make-plots \
			${PN}-mkhtml \
			${PN}-mkhtml-mpl
		rm "${ED}"/etc/bash_completion.d/${PN}-completion || die
	fi
}

pkg_postinstall() {
	optfeature "plotting support" virtual/latex-base media-gfx/imagemagick app-text/ghostscript-gpl
}
