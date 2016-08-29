# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils libtool toolchain-funcs multilib-minimal

DESCRIPTION="Extended attributes tools"
HOMEPAGE="https://savannah.nongnu.org/projects/attr"
SRC_URI="mirror://nongnu/${PN}/${P}.src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="nls static-libs"

DEPEND="nls? ( sys-devel/gettext )
	sys-devel/autoconf"
RDEPEND="abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224-r9
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"

src_prepare() {
	sed -i \
		-e "/^PKG_DOC_DIR/s:@pkg_name@:${PF}:" \
		-e '/HAVE_ZIPPED_MANPAGES/s:=.*:=false:' \
		include/builddefs.in \
		|| die
	strip-linguas -u po
	elibtoolize #580792

	multilib_copy_sources # https://savannah.nongnu.org/bugs/index.php?39736
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

multilib_src_compile() {
	emake $(multilib_is_native_abi || echo TOOL_SUBDIRS=)
}

multilib_src_install() {
	emake \
		$(multilib_is_native_abi || echo TOOL_SUBDIRS=) \
		DIST_ROOT="${D}" \
		install install-lib install-dev

	if multilib_is_native_abi; then
		# we install attr into /bin, so we need the shared lib with it
		gen_usr_ldscript -a attr
		# the man-pages packages provides the man2 files
		# note: man-pages are installed by TOOL_SUBDIRS
		rm -r "${ED}"/usr/share/man/man2 "${ED}"/usr/share/man/man5/attr.5 || die
	fi
}

multilib_src_install_all() {
	use static-libs || prune_libtool_files --all
	einstalldocs
}
