# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 scons-utils toolchain-funcs vcs-snapshot

MY_P="${P#*-}"

DESCRIPTION="SunPinyin IMEngine for SCIM"
HOMEPAGE="https://github.com/sunpinyin/sunpinyin"
SRC_URI="https://github.com/${PN#*-}/${PN#*-}/archive/v${PV/_rc/-rc}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk3"

RDEPEND="app-i18n/scim[gtk3=]
	~app-i18n/sunpinyin-${PV}:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	tc-export CXX
}

src_compile() {
	escons -C wrapper/scim \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--libexecdir="${EPREFIX}"/usr/libexec
}

src_install() {
	escons -C wrapper/scim --install-sandbox="${D}" install
	dodoc wrapper/scim/README
}
