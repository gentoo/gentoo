# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="https://gitlab.com/ixion/ixion.git"

PYTHON_COMPAT=( python3_{4,5} )

[[ ${PV} == 9999 ]] && GITECLASS="git-r3 autotools"
inherit eutils python-single-r1 ${GITECLASS}
unset GITECLASS

DESCRIPTION="General purpose formula parser & interpreter"
HOMEPAGE="https://gitlab.com/ixion/ixion"
[[ ${PV} == 9999 ]] || SRC_URI="http://kohei.us/files/ixion/src/${P}.tar.xz"

LICENSE="MIT"
SLOT="0/0.12" # based on SONAME of libixion.so
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="debug python static-libs +threads"

RDEPEND="
	dev-libs/boost:=
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	>=dev-util/mdds-1.2.0:1=
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable python) \
		$(use_enable static-libs static) \
		$(use_enable threads)
}

src_install() {
	default

	prune_libtool_files --all
}
