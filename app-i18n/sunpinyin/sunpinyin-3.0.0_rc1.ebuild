# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 scons-utils toolchain-funcs vcs-snapshot

DESCRIPTION="A Statistical Language Model based Chinese input method library"
HOMEPAGE="https://github.com/sunpinyin/sunpinyin"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV/_rc/-rc}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 CDDL"
SLOT="0/3"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"
PDEPEND=">=app-i18n/sunpinyin-data-20140820"

src_prepare() {
	sed -i "/^docdir/s/${PN}/${PF}/" SConstruct

	default
	tc-export CXX
}

src_compile() {
	escons \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir)
}

src_install() {
	escons --install-sandbox="${D}" install
}
