# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
ADA_COMPAT=( gnat_201{7,8,9} )

inherit ada python-single-r1

MYP=${PN}-gpl-${PV}-src
DESCRIPTION="high performance semantic engine for the Ada programming language"
HOMEPAGE="https://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5b0cf9adc7a4475263382c18
	-> ${MYP}.tar.gz"

LICENSE="GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+shared static-libs"

RDEPEND="dev-python/pyyaml
	dev-ada/gnatcoll-bindings[${ADA_USEDEP},iconv,shared=,static-libs=]
	${ADA_DEPS}
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	~dev-ada/langkit-2018
	dev-ada/gprbuild[${ADA_USEDEP}]"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	${ADA_REQUIRED_USE}"

S="${WORKDIR}"/${MYP}

pkg_setup() {
	python-single-r1_pkg_setup
	ada_pkg_setup
}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${PN}-2017-gentoo.patch
)

src_configure() {
	ada/manage.py -v debug generate || die
}

src_compile() {
	ada/manage.py \
		-v \
		$(use_enable shared) \
		$(use_enable static-libs static) \
		build \
		--build-mode='prod' || die
}

src_test () {
	ada/manage.py test | grep FAILED && die
}

src_install () {
	ada/manage.py \
		$(use_enable shared) \
		$(use_enable static-libs static) \
		install "${D}"/usr || die
	python_domodule build/python/libadalang.py
	rm -r "${D}"/usr/python || die
}
