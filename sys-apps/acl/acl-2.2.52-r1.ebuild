# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs multilib-minimal

DESCRIPTION="access control list utilities, libraries and headers"
HOMEPAGE="http://savannah.nongnu.org/projects/acl"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux"
IUSE="nls static-libs"

RDEPEND=">=sys-apps/attr-2.4.47-r1[${MULTILIB_USEDEP}]
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140406-r2
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	sed -i \
		-e "/^PKG_DOC_DIR/s:@pkg_name@:${PF}:" \
		-e '/HAVE_ZIPPED_MANPAGES/s:=.*:=false:' \
		include/builddefs.in \
		|| die
	strip-linguas po

	# same as https://savannah.nongnu.org/bugs/index.php?39736
	multilib_copy_sources
}

multilib_src_configure() {
	unset PLATFORM #184564
	export OPTIMIZER=${CFLAGS}
	export DEBUG=-DNDEBUG

	econf \
		$(use_enable nls gettext) \
		--enable-shared $(use_enable static-libs static) \
		--libexecdir="${EPREFIX}"/usr/$(get_libdir) \
		--bindir="${EPREFIX}"/bin
}

multilib_src_install() {
	emake DIST_ROOT="${D}" install install-dev install-lib

	# move shared libs to /
	gen_usr_ldscript -a acl
}

multilib_src_install_all() {
	use static-libs || prune_libtool_files --all
}
