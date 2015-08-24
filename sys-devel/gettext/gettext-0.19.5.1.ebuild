# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit flag-o-matic eutils multilib toolchain-funcs mono-env libtool java-pkg-opt-2 multilib-minimal

DESCRIPTION="GNU locale utilities"
HOMEPAGE="https://www.gnu.org/software/gettext/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="acl -cvs doc emacs git java nls +cxx ncurses openmp static-libs elibc_glibc elibc_musl"

# only runtime goes multilib
DEPEND=">=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	dev-libs/libxml2
	dev-libs/expat
	acl? ( virtual/acl )
	ncurses? ( sys-libs/ncurses )
	java? ( >=virtual/jdk-1.4 )"
RDEPEND="${DEPEND}
	!git? ( cvs? ( dev-vcs/cvs ) )
	git? ( dev-vcs/git )
	java? ( >=virtual/jre-1.4 )
	abi_x86_32? (
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
		!<=app-emulation/emul-linux-x86-baselibs-20131008-r11
	)"
PDEPEND="emacs? ( app-emacs/po-mode )"

MULTILIB_WRAPPED_HEADERS=(
	# only installed for native ABI
	/usr/include/gettext-po.h
)

src_prepare() {
	java-pkg-opt-2_src_prepare
	epunt_cxx
	elibtoolize
}

multilib_src_configure() {
	local myconf=(
		# switches common to runtime and top-level
		--cache-file="${BUILD_DIR}"/config.cache
		--docdir="/usr/share/doc/${PF}"

		$(use_enable cxx libasprintf)
		$(use_enable java)
		$(use_enable static-libs static)
	)

	# Build with --without-included-gettext (on glibc systems)
	if use elibc_glibc || use elibc_musl ; then
		myconf+=(
			--without-included-gettext
			$(use_enable nls)
		)
	else
		myconf+=(
			--with-included-gettext
			--enable-nls
		)
	fi
	use cxx || export CXX=$(tc-getCC)

	# Should be able to drop this hack in next release. #333887
	tc-is-cross-compiler && export gl_cv_func_working_acl_get_file=yes

	local ECONF_SOURCE=${S}
	if ! multilib_is_native_abi ; then
		# for non-native ABIs, we build runtime only
		ECONF_SOURCE+=/gettext-runtime
	else
		# remaining switches
		myconf+=(
			# Emacs support is now in a separate package
			--without-emacs
			--without-lispdir
			# glib depends on us so avoid circular deps
			--with-included-glib
			# libcroco depends on glib which ... ^^^
			--with-included-libcroco
			# this will _disable_ libunistring (since it is not bundled),
			# see bug #326477
			--with-included-libunistring

			$(use_enable acl)
			$(use_enable ncurses curses)
			$(use_enable openmp)
			$(use_with git)
			$(usex git --without-cvs $(use_with cvs))
		)
	fi

	econf "${myconf[@]}"
}

multilib_src_install() {
	default

	if multilib_is_native_abi ; then
		dosym msgfmt /usr/bin/gmsgfmt #43435
		dobin gettext-tools/misc/gettextize

		[[ ${USERLAND} == "BSD" ]] && gen_usr_ldscript -a intl
	fi
}

multilib_src_install_all() {
	use nls || rm -r "${D}"/usr/share/locale
	use static-libs || prune_libtool_files --all

	rm -f "${D}"/usr/share/locale/locale.alias "${D}"/usr/lib/charset.alias

	if use java ; then
		java-pkg_dojar "${D}"/usr/share/${PN}/*.jar
		rm -f "${D}"/usr/share/${PN}/*.jar
		rm -f "${D}"/usr/share/${PN}/*.class
		if use doc ; then
			java-pkg_dojavadoc "${D}"/usr/share/doc/${PF}/javadoc2
			rm -rf "${D}"/usr/share/doc/${PF}/javadoc2
		fi
	fi

	if use doc ; then
		dohtml "${D}"/usr/share/doc/${PF}/*.html
	else
		rm -rf "${D}"/usr/share/doc/${PF}/{csharpdoc,examples,javadoc2,javadoc1}
	fi
	rm -f "${D}"/usr/share/doc/${PF}/*.html

	dodoc AUTHORS ChangeLog NEWS README THANKS
}

pkg_preinst() {
	java-pkg-opt-2_pkg_preinst
}
