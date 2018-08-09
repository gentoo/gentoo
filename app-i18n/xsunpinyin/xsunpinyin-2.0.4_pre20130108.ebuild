# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 scons-utils toolchain-funcs

DESCRIPTION="A standalone XIM server for SunPinyin"
HOMEPAGE="https://github.com/sunpinyin/sunpinyin"
SRC_URI="https://dev.gentoo.org/~yngwin/distfiles/sunpinyin-${PV}.tar.xz"

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="~app-i18n/sunpinyin-${PV}:=
	x11-libs/gtk+:2
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
S="${WORKDIR}/${P:1}"

src_prepare() {
	default
	tc-export CXX
}

src_compile() {
	escons -C wrapper/xim \
		--prefix="${EPREFIX}"/usr
}

src_install() {
	escons -C wrapper/xim --install-sandbox="${D}" install
	dodoc wrapper/xim/README
}
