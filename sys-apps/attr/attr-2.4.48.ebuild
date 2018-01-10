# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit libtool ltprune toolchain-funcs multilib-minimal

DESCRIPTION="Extended attributes tools"
HOMEPAGE="https://savannah.nongnu.org/projects/attr"
# Self-hosting as savannah does not provide a tarball on their download
# area and the tarball in their git repo requires autoreconf to be run.
SRC_URI="https://dev.gentoo.org/~polynomial-c/dist/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="debug static-libs"

DEPEND="
	sys-devel/autoconf
	sys-devel/gettext
"

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
		--enable-shared $(use_enable static-libs static)
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		$(use_enable debug)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi; then
		# we install attr into /bin, so we need the shared lib with it
		gen_usr_ldscript -a attr
	fi
}

multilib_src_install_all() {
	use static-libs || prune_libtool_files --all
	einstalldocs
}
