# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libixion/libixion-0.9.1.ebuild,v 1.4 2015/07/25 21:23:20 dilfridge Exp $

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
	>=dev-util/mdds-0.12.0:=
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.9.1-typo.patch"
	epatch "${FILESDIR}/${PN}-0.9.1-python-optional.patch"
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
