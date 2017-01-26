# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit perl-functions python-r1 toolchain-funcs

MY_PV=${PV//_/}

DESCRIPTION="A rapid whole genome aligner"
HOMEPAGE="http://mummer.sourceforge.net/"
SRC_URI="https://github.com/gmarcais/${PN}/releases/download/v${MY_PV}/${PN}-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
IUSE="openmp perl python"
KEYWORDS="~amd64 ~x86"

DEPEND="
	python? (
		${PYTHON_DEPS}
		dev-lang/swig:0
	)"
RDEPEND="
	app-shells/tcsh
	dev-lang/perl:=
	python? ( ${PYTHON_DEPS} )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S=${WORKDIR}/${PN}-${MY_PV}

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	use python && preamble="python_foreach_impl run_in_build_dir"
}

src_configure() {
	perl_set_version
	configure() {
		local pythonconf
		if use python; then
			pythonconf="--enable-python-binding=$(python_get_sitedir)"
		else
			pythonconf="--disable-python-binding"
		fi

		ECONF_SOURCE="${S}" econf \
			--disable-static \
			--disable-ruby-binding \
			$(use_enable perl perl-binding "${VENDOR_LIB}") \
			$(use_enable openmp) \
			$(use_enable python swig) \
			"${pythonconf}"
	}
	${preamble} configure
}

src_compile() {
	${preamble} default
}

src_install() {
	${preamble} default
	einstalldocs

	# avoid file collision
	mv "${ED%/}"/usr/bin/{,mummer-}annotate || die

	# move perl module into right place
	mkdir -p "${D%/}${VENDOR_LIB}" || die
	mv "${ED%/}"/usr/$(get_libdir)/mummer/Foundation.pm "${D%/}${VENDOR_LIB}" || die

	# no static libs, can purge .la files
	find "${D}" -name '*.la' -delete || die
}
