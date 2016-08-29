# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Note: Keep version bumps in sync with dev-libs/libintl.

EAPI="5"

inherit eutils mono-env libtool java-pkg-opt-2 multilib-minimal

DESCRIPTION="GNU locale utilities"
HOMEPAGE="https://www.gnu.org/software/gettext/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

# Only libasprintf is under the LGPL (and libintl is in a sep package),
# so put that license behind USE=cxx.
LICENSE="GPL-3+ cxx? ( LGPL-2.1+ )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="acl -cvs +cxx doc emacs git java ncurses nls openmp static-libs"

# only runtime goes multilib
# Note: expat lacks a subslot because it is dynamically loaded at runtime.  We
# would depend on older subslots if they were available (based on the ABIs that
# are explicitly handled), but expat doesn't currently use subslots.
DEPEND=">=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	>=virtual/libintl-0-r2[${MULTILIB_USEDEP}]
	dev-libs/libxml2:=
	dev-libs/expat
	acl? ( virtual/acl )
	ncurses? ( sys-libs/ncurses:0= )
	java? ( >=virtual/jdk-1.4:= )"
RDEPEND="${DEPEND}
	!git? ( cvs? ( dev-vcs/cvs ) )
	git? ( dev-vcs/git )
	java? ( >=virtual/jre-1.4 )"
PDEPEND="emacs? ( app-emacs/po-mode )"

MULTILIB_WRAPPED_HEADERS=(
	# only installed for native ABI
	/usr/include/gettext-po.h
)

pkg_setup() {
	mono-env_pkg_setup
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	java-pkg-opt-2_src_prepare

	epatch "${FILESDIR}"/${PN}-0.19.7-disable-libintl.patch #564168

	epunt_cxx
	elibtoolize
}

multilib_src_configure() {
	local myconf=(
		# switches common to runtime and top-level
		--cache-file="${BUILD_DIR}"/config.cache
		--docdir="\$(datarootdir)/doc/${PF}"

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
		# Never build libintl since it's in dev-libs/libintl now.
		--without-included-gettext

		$(use_enable acl)
		$(use_enable cxx c++)
		$(use_enable cxx libasprintf)
		$(use_with git)
		$(usex git --without-cvs $(use_with cvs))
		$(use_enable java)
		$(use_enable ncurses curses)
		$(use_enable nls)
		$(use_enable openmp)
		$(use_enable static-libs static)
	)

	local ECONF_SOURCE=${S}
	if ! multilib_is_native_abi ; then
		# for non-native ABIs, we build runtime only
		ECONF_SOURCE+=/gettext-runtime
	fi

	econf "${myconf[@]}"
}

multilib_src_install() {
	default

	if multilib_is_native_abi ; then
		dosym msgfmt /usr/bin/gmsgfmt #43435
		dobin gettext-tools/misc/gettextize
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
