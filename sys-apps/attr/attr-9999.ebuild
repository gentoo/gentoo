# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic libtool toolchain-funcs multilib-minimal usr-ldscript

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/${PN}.git"

	inherit autotools git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
	SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"
fi

DESCRIPTION="Extended attributes tools"
HOMEPAGE="https://savannah.nongnu.org/projects/attr"
LICENSE="LGPL-2.1"
SLOT="0"

IUSE="debug nls static-libs"

DEPEND="nls? ( sys-devel/gettext )"

pkg_setup() {
	# Remove -flto* from flags as this breaks binaries (bug #644048)
	filter-flags -flto*
}

src_prepare() {
	default

	if [[ ${PV} == 9999 ]] ; then
		po/update-potfiles || die
		eautopoint
		eautoreconf
	else
		elibtoolize #580792
	fi
}

multilib_src_configure() {
	unset PLATFORM #184564
	export OPTIMIZER=${CFLAGS}
	export DEBUG=-DNDEBUG

	tc-ld-disable-gold #644048

	local myeconfargs=(
		--bindir="${EPREFIX%/}"/bin
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable nls)
		--libexecdir="${EPREFIX%/}"/usr/$(get_libdir)
		$(use_enable debug)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	# Sanity check until we track down why this is happening. #644048
	local lib="${ED}/usr/$(get_libdir)/libattr.so.1"
	if [[ -e ${lib} ]] ; then
		local versions=$(readelf -V "${lib}")
		local symbols=$(readelf -sW "${lib}")
		if [[ "${versions}" != *"ATTR_1.0"* || \
		      "${versions}" != *"ATTR_1.1"* || \
		      "${versions}" != *"ATTR_1.2"* || \
		      "${versions}" != *"ATTR_1.3"* || \
		      "${symbols}" != *"getxattr@ATTR_1.0"* ]] ; then
			echo "# readelf -V ${lib}"
			echo "${versions}"
			echo "# readelf -sW ${lib}"
			echo "${symbols}"
			die "symbol version sanity check failed; please comment on https://bugs.gentoo.org/644048"
		else
			einfo "${lib} passed symbol checks"
		fi
	fi

	if multilib_is_native_abi; then
		# we install attr into /bin, so we need the shared lib with it
		gen_usr_ldscript -a attr
	fi

	# Add a wrapper until people upgrade.
	insinto /usr/include/attr
	newins "${FILESDIR}"/xattr-shim.h xattr.h
}

multilib_src_install_all() {
	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi

	einstalldocs
}
