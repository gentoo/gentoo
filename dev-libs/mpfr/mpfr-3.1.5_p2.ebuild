# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# NOTE: we cannot depend on autotools here starting with gcc-4.3.x
inherit eutils libtool multilib-minimal

MY_PV=${PV/_p*}
MY_P=${PN}-${MY_PV}
PLEVEL=${PV/*p}
DESCRIPTION="library for multiple-precision floating-point computations with exact rounding"
HOMEPAGE="https://www.mpfr.org/"
SRC_URI="https://www.mpfr.org/mpfr-${MY_PV}/${MY_P}.tar.xz
	https://dev.gentoo.org/~mgorny/dist/${MY_P}-patchset.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0/4" # libmpfr.so version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND=">=dev-libs/gmp-4.1.4-r2[${MULTILIB_USEDEP},static-libs?]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	if [[ ${PLEVEL} != ${PV} ]] ; then
		local i
		for (( i = 1; i <= PLEVEL; ++i )) ; do
			epatch "${WORKDIR}"/${MY_P}-patchset/patch$(printf '%02d' ${i})
		done
	fi
	epatch_user
	find . -type f -exec touch -r configure {} +
	elibtoolize
}

multilib_src_configure() {
	# Make sure mpfr doesn't go probing toolchains it shouldn't #476336#19
	ECONF_SOURCE=${S} \
	user_redefine_cc=yes \
	econf \
		--docdir="\$(datarootdir)/doc/${PF}" \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	use static-libs || find "${ED}"/usr -name '*.la' -delete

	# clean up html/license install
	pushd "${ED}"/usr/share/doc/${PF} >/dev/null || die
	dohtml *.html && rm COPYING* *.html
	popd >/dev/null || die
}
