# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libixion/libixion-9999.ebuild,v 1.14 2015/06/21 15:35:49 dilfridge Exp $

EAPI=5

EGIT_REPO_URI="https://gitlab.com/ixion/ixion.git"

PYTHON_COMPAT=( python{3_3,3_4} )

[[ ${PV} == 9999 ]] && GITECLASS="git-r3 autotools"
inherit eutils python-single-r1 ${GITECLASS}
unset GITECLASS

DESCRIPTION="General purpose formula parser & interpreter"
HOMEPAGE="https://gitlab.com/ixion/ixion"
[[ ${PV} == 9999 ]] || SRC_URI="http://kohei.us/files/ixion/src/${P}.tar.xz"

LICENSE="MIT"
SLOT="0/0.12"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="python static-libs"

RDEPEND="
	dev-libs/boost:=
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	>=dev-util/mdds-0.12.0:=
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

src_prepare() {
	[[ ${PV} == 9999 ]] && eautoreconf
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
