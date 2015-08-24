# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 scons-utils toolchain-funcs

DESCRIPTION="The SunPinYin IMEngine for IBus Framework"
HOMEPAGE="https://sunpinyin.googlecode.com/"
SRC_URI="https://dev.gentoo.org/~yngwin/distfiles/sunpinyin-${PV}.tar.xz"

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+nls"

RDEPEND="${PYTHON_DEPS}
	app-i18n/ibus[python,${PYTHON_USEDEP}]
	~app-i18n/sunpinyin-${PV}:=
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

src_unpack() {
	default
	mv "${WORKDIR}/sunpinyin-${PV}" "${S}" || die
}

src_prepare() {
	sed -i -e "s/python/${EPYTHON}/" wrapper/ibus/setup/ibus-setup-sunpinyin.in || die
}

src_configure() {
	tc-export CXX
	myesconsargs=(
		--prefix="${EPREFIX}"/usr
		--libexecdir="${EPREFIX}"/usr/libexec
	)
}

src_compile() {
	escons -C wrapper/ibus
}

src_install() {
	escons -C wrapper/ibus --install-sandbox="${ED}" install
}
