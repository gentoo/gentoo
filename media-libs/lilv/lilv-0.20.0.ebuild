# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE='threads(+)'

inherit base python-any-r1 waf-utils bash-completion-r1

DESCRIPTION="Library to make the use of LV2 plugins as simple as possible for applications"
HOMEPAGE="http://drobilla.net/software/lilv/"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc +dyn-manifest static-libs test"

RDEPEND="media-libs/lv2
	>=media-libs/sratom-0.4.0
	>=dev-libs/serd-0.14.0
	>=dev-libs/sord-0.12.0"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

DOCS=( "AUTHORS" "NEWS" "README" )

src_prepare() {
	sed -i -e 's/^.*run_ldconfig/#\0/' wscript || die
}

src_configure() {
	waf-utils_src_configure \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--no-bash-completion \
		$(use test && echo "--test") \
		$(use doc && echo "--docs") \
		$(use static-libs && echo "--static") \
		$(use dyn-manifest && echo "--dyn-manifest")
}

src_test() {
	./waf test || die
}

src_install() {
	waf-utils_src_install
	newbashcomp utils/lilv.bash_completion ${PN}
}
