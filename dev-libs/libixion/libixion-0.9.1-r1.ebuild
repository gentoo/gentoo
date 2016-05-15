# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="https://gitlab.com/ixion/ixion.git"

PYTHON_COMPAT=( python2_7 )

[[ ${PV} == 9999 ]] && GITECLASS="git-r3"
inherit autotools eutils python-single-r1 ${GITECLASS}
unset GITECLASS

DESCRIPTION="General purpose formula parser & interpreter"
HOMEPAGE="https://gitlab.com/ixion/ixion"
[[ ${PV} == 9999 ]] || SRC_URI="http://kohei.us/files/ixion/src/${P}.tar.xz"

LICENSE="MIT"
SLOT="0/0.10" # based on SONAME of libixion.so
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="python static-libs"

RDEPEND="
	dev-libs/boost:=[threads]
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	>=sys-devel/boost-m4-0.4_p20160328
	>=dev-util/mdds-0.12.0:0=
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
PATCHES=(
	"${FILESDIR}/${PN}-0.9.1-typo.patch"
	"${FILESDIR}/${PN}-0.9.1-python-optional.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# fixes bug 576462, which is due to an outdated bundled boost.m4
	rm m4/boost.m4 || die

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
