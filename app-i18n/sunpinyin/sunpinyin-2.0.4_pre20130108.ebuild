# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/sunpinyin/sunpinyin-2.0.4_pre20130108.ebuild,v 1.5 2015/05/01 05:52:40 jer Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils multilib python-any-r1 scons-utils toolchain-funcs

DESCRIPTION="A Statistical Language Model based Chinese input method library"
HOMEPAGE="https://sunpinyin.googlecode.com/"
SRC_URI="http://dev.gentoo.org/~yngwin/distfiles/${P}.tar.xz"

LICENSE="LGPL-2.1 CDDL"
SLOT="0/1"
KEYWORDS="amd64 ~ppc ppc64 ~x86"
IUSE=""

RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"
PDEPEND="app-i18n/sunpinyin-data"

src_prepare() {
	epatch_user
}

src_configure() {
	tc-export CXX
	myesconsargs=(
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}"/usr/$(get_libdir)
	)
}

src_compile() {
	escons
}

src_install() {
	escons --install-sandbox="${ED}" install
	rm -rf "${D}"/usr/share/doc/${PN} || die
	dodoc doc/{README,SLM-inst.mk,SLM-train.mk}
}
