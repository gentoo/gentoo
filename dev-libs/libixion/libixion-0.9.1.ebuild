# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="https://gitlab.com/ixion/ixion.git"

PYTHON_COMPAT=( python2_7 )

[[ ${PV} == 9999 ]] && GITECLASS="git-r3"
inherit autotools eutils python-single-r1 ${GITECLASS}
unset GITECLASS

DESCRIPTION="General purpose formula parser & interpreter"
HOMEPAGE="https://gitlab.com/ixion/ixion"
[[ ${PV} == 9999 ]] || SRC_URI="http://kohei.us/files/ixion/src/${P}.tar.xz"

LICENSE="MIT"
SLOT="0/0.10"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="python static-libs"

RDEPEND="
	dev-libs/boost:=[threads]
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	>=dev-util/mdds-0.12.0:0=
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.9.1-typo.patch" \
		"${FILESDIR}/${PN}-0.9.1-python-optional.patch" \
		"${FILESDIR}/${PN}-0.9.1-python-symbol.patch"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable python) \
		$(use_enable static-libs static)
}

src_install() {
	default

	prune_libtool_files --all
}
