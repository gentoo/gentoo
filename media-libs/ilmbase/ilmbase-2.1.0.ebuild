# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/ilmbase/ilmbase-2.1.0.ebuild,v 1.11 2015/05/17 20:12:10 pacho Exp $

EAPI=5
inherit autotools-multilib

DESCRIPTION="OpenEXR ILM Base libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="http://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/11" # 11 from SONAME
KEYWORDS="alpha amd64 -arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="static-libs"

DOCS=( AUTHORS ChangeLog NEWS README )
MULTILIB_WRAPPED_HEADERS=( /usr/include/OpenEXR/IlmBaseConfig.h )

src_configure() {
	# Disable use of ucontext.h wrt #482890
	if use hppa || use ppc || use ppc64; then
		export ac_cv_header_ucontext_h=no
	fi

	autotools-multilib_src_configure
}
