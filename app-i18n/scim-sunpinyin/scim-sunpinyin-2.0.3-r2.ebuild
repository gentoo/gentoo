# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 scons-utils toolchain-funcs

DESCRIPTION="SunPinyin IMEngine for SCIM"
HOMEPAGE="https://github.com/sunpinyin/sunpinyin"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN#*-}/${P}.tar.gz"

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-i18n/scim
	~app-i18n/sunpinyin-${PV}:=
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-force-switch.patch )

src_prepare() {
	default
	tc-export CXX
}

src_compile() {
	escons \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--libexecdir="${EPREFIX}"/usr/libexec
}

src_install() {
	escons --install-sandbox="${D}" install
	einstalldocs
}
