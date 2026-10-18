# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please bump with dev-build/libtool.

inherit multilib-minimal flag-o-matic

MY_P="libtool-${PV}"

DESCRIPTION="A shared library tool for developers"
HOMEPAGE="https://www.gnu.org/software/libtool/"
if ! [[ $(( $(ver_cut 2) % 2 )) -eq 0 ]] ; then
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/libtool.asc
	inherit verify-sig
	# Note that sometimes alpha versions have different versioning
	# than this, so check on bumps!
	SRC_URI="
		https://alpha.gnu.org/gnu/libtool/${MY_P}.tar.xz
		verify-sig? ( https://alpha.gnu.org/gnu/libtool/${MY_P}.tar.xz.sig )
	"

	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-libtool )"
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/libtool.asc
	inherit verify-sig

	SRC_URI="
		mirror://gnu/libtool/${MY_P}.tar.xz
		verify-sig? ( mirror://gnu/libtool/${MY_P}.tar.xz.sig )
	"

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-libtool )"
fi

S="${WORKDIR}"/${MY_P}/libltdl

LICENSE="LGPL-2+"
SLOT="0"
IUSE="static-libs"
# libltdl doesn't have a testsuite.  Don't bother trying.
RESTRICT="test"

BDEPEND+=" app-arch/xz-utils"

multilib_src_configure() {
	# bug #907427
	filter-lto

	append-lfs-flags
	ECONF_SOURCE="${S}" \
	econf \
		--enable-ltdl-install \
		$(use_enable static-libs static)
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	# While the libltdl.la file is not used directly, the m4 ltdl logic
	# keys off of its existence when searching for ltdl support. # bug #293921
	#use static-libs || find "${D}" -name libltdl.la -delete
}
