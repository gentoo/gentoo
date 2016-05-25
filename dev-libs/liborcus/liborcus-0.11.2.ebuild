# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="https://gitlab.com/orcus/orcus.git"

PYTHON_COMPAT=( python{3_4,3_5} )

[[ ${PV} == 9999 ]] && GITECLASS="git-r3 autotools"
inherit eutils python-single-r1 ${GITECLASS}
unset GITECLASS

DESCRIPTION="Standalone file import filter library for spreadsheet documents"
HOMEPAGE="https://gitlab.com/orcus/orcus/blob/master/README.md"
[[ ${PV} == 9999 ]] || SRC_URI="http://kohei.us/files/orcus/src/${P}.tar.xz"

LICENSE="MIT"
SLOT="0/0.11" # based on SONAME of liborcus.so
[[ ${PV} == 9999 ]] || \
KEYWORDS=""
# KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="python +spreadsheet-model static-libs tools"

RDEPEND="
	>=dev-libs/boost-1.51.0:=
	sys-libs/zlib:=
	python? ( ${PYTHON_DEPS} )
	spreadsheet-model? ( >=dev-libs/libixion-0.11.1:= )
"
DEPEND="${RDEPEND}
	>=dev-util/mdds-1.2.0:1
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	eapply_user
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		--disable-werror \
		$(use_enable python) \
		$(use_enable spreadsheet-model) \
		$(use_enable static-libs static) \
		$(use_with tools)
}

src_install() {
	default

	prune_libtool_files --all
}
