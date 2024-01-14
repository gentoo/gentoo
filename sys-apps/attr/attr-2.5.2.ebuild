# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal usr-ldscript

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/${PN}.git"
	inherit autotools git-r3
else
	inherit libtool

	SRC_URI="mirror://nongnu/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Extended attributes tools"
HOMEPAGE="https://savannah.nongnu.org/projects/attr"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="debug nls static-libs"

BDEPEND="nls? ( sys-devel/gettext )"

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
	local myeconfargs=(
		--bindir="${EPREFIX}"/bin
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable nls)
		$(use_enable debug)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi; then
		# We install attr into /bin, so we need the shared lib with it
		gen_usr_ldscript -a attr
	fi

	# Add a wrapper until people upgrade.
	# TODO: figure out when this was added & when we can drop it!
	insinto /usr/include/attr
	newins "${FILESDIR}"/xattr-shim.h xattr.h
}

multilib_src_install_all() {
	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi

	einstalldocs
}
