# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit bash-completion-r1 autotools python-single-r1

DESCRIPTION="Yet more Objects for (High Energy Physics) Data Analysis"
HOMEPAGE="https://yoda.hepforge.org/"
SRC_URI="https://yoda.hepforge.org/downloads?f=${P^^}.tar.bz2 -> ${P^^}.tar.bz2"
S="${WORKDIR}/${P^^}"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="root python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} ) root? ( python )"

RDEPEND="
	root? ( sci-physics/root:=[${PYTHON_SINGLE_USEDEP}] )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	# reconf due to python3_10 patch
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable root) \
		$(use_enable python pyext)
}

src_test() {
	# PYTESTS and SHTESTS both require python tools to be installed already
	emake check PYTESTS= SHTESTS=
}

src_install() {
	# prevent double installation of python library
	emake install DESTDIR="${ED}"
	find "${ED}" -name '*.la' -delete || die
	newbashcomp "${ED}"/etc/bash_completion.d/${PN}-completion yoda
	python_optimize
	rm "${ED}"/etc/bash_completion.d/${PN}-completion || die
}
