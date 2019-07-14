# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit libtool ltprune toolchain-funcs multilib-minimal usr-ldscript

DESCRIPTION="Extended attributes tools"
HOMEPAGE="https://savannah.nongnu.org/projects/attr"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug nls static-libs"

DEPEND="nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}/${P}-perl-5.26.patch"
)

src_prepare() {
	default
	elibtoolize #580792
}

multilib_src_configure() {
	unset PLATFORM #184564
	export OPTIMIZER=${CFLAGS}
	export DEBUG=-DNDEBUG

	tc-ld-disable-gold #644048

	local myeconfargs=(
		--bindir="${EPREFIX}"/bin
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable nls)
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
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
	use static-libs || prune_libtool_files --all
	einstalldocs
}
