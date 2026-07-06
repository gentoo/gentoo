# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a libtool multilib-minimal

DESCRIPTION="Access control list utilities, libraries, and headers"
HOMEPAGE="https://savannah.nongnu.org/projects/acl"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/${PN}.git"
	inherit autotools git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/acl.asc"
	inherit verify-sig

	SRC_URI="
		mirror://nongnu/${PN}/${P}.tar.xz
		verify-sig? ( mirror://nongnu/${PN}/${P}.tar.xz.sig )
	"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-acl )"
fi

LICENSE="LGPL-2.1+ GPL-2"
SLOT="0"
IUSE="nls static-libs"

BDEPEND+=" nls? ( sys-devel/gettext )"

src_prepare() {
	default

	if [[ ${PV} == 9999 ]] ; then
		po/update-potfiles || die
		eautopoint
		eautoreconf
	else
		# bug #580792
		elibtoolize
	fi
}

multilib_src_configure() {
	use static-libs && lto-guarantee-fat

	local myeconfargs=(
		--bindir="${EPREFIX}"/bin
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		--enable-largefile
		$(use_enable static-libs static)
		$(use_enable nls)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	# Tests call native binaries with an LD_PRELOAD wrapper
	# bug #772356
	multilib_is_native_abi && default
}

multilib_src_install_all() {
	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi

	strip-lto-bytecode
	einstalldocs
}
