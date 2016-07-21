# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDEBASE="kdevelop"
KMNAME="kdev-python"
KDE_LINGUAS="bs ca ca@valencia de en_GB es et fi fr gl it nl pl pt pt_BR sk sl sv tr uk"
PYTHON_COMPAT=( python2_7 )
MY_P="${KMNAME}-${PV}"
inherit kde4-base python-any-r1

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/kdevelop/${KDEVELOP_VERSION}/src/${MY_P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/${MY_P}
fi

DESCRIPTION="Python plugin for KDevelop 4"
IUSE="debug"

DEPEND="
	${PYTHON_DEPS}
"
RDEPEND="
	dev-util/kdevelop:4
"

RESTRICT="test"

pkg_setup() {
	python-any-r1_pkg_setup
	kde4-base_pkg_setup
}

src_compile() {
	pushd "${WORKDIR}"/${P}_build > /dev/null || die
	emake parser
	popd > /dev/null || die

	kde4-base_src_compile
}
