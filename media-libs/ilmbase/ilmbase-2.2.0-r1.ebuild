# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib-minimal

DESCRIPTION="OpenEXR ILM Base libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="http://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/12" # based on SONAME
KEYWORDS="amd64 -arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="static-libs"

DEPEND="virtual/pkgconfig[${MULTILIB_USEDEP}]"

DOCS=( AUTHORS ChangeLog NEWS README )
MULTILIB_WRAPPED_HEADERS=( /usr/include/OpenEXR/IlmBaseConfig.h )

PATCHES=( "${FILESDIR}/${P}-Remove-register-keyword.patch" )

multilib_src_configure() {
	# Disable use of ucontext.h wrt #482890
	if use hppa || use ppc || use ppc64; then
		export ac_cv_header_ucontext_h=no
	fi

	ECONF_SOURCE=${S} econf "$(use_enable static-libs static)"
}
