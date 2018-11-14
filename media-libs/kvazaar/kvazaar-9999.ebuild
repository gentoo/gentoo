# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

SCM=""

GREATEST_PV="1.2.1"

if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ultravideo/kvazaar"
fi

inherit eutils multilib autotools multilib-minimal toolchain-funcs flag-o-matic ${SCM}

DESCRIPTION="An open-source HEVC encoder"
HOMEPAGE="http://ultravideo.cs.tut.fi/ https://github.com/ultravideo/kvazaar"

if [ "${PV#9999}" = "${PV}" ] ; then
	SRC_URI="https://github.com/ultravideo/kvazaar/archive/v${PV}.tar.gz -> ${P}.tar.gz
		test? ( https://github.com/silentbicycle/greatest/archive/v${GREATEST_PV}.tar.gz -> greatest-${GREATEST_PV}.tar.gz )"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
fi

LICENSE="LGPL-2.1"
# subslot = libkvazaar major
SLOT="0/4"
IUSE="static-libs test"

DEPEND=""
RDEPEND="${DEPEND}"
REQUIRED_USE="test? ( static-libs )"

ASM_DEP=">=dev-lang/yasm-1.2.0"
DEPEND="${DEPEND}
	abi_x86_32? ( ${ASM_DEP} )
	abi_x86_64? ( ${ASM_DEP} )"

src_prepare() {
	eautoreconf
	if use test && [ "${PV#9999}" = "${PV}" ]; then
		# https://bugs.gentoo.org/show_bug.cgi?id=595932
		rmdir "${S}/greatest" || die
		mv "${WORKDIR}/greatest-${GREATEST_PV}" "${S}/greatest" || die
	fi
	# Some m4 macros append Werror, we do not want that.
	append-flags "-Wno-error"
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
		econf \
			--disable-werror \
			--docdir "/usr/share/doc/${PF}" \
			$(use_enable static-libs static)
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete
}
