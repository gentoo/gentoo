# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Note: Keep version bumps in sync with dev-libs/libintl.

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/gettext.asc
inherit java-pkg-opt-2 libtool multilib-minimal verify-sig toolchain-funcs

DESCRIPTION="GNU locale utilities"
HOMEPAGE="https://www.gnu.org/software/gettext/"
if [[ ${PV} == *_rc* ]] ; then
	SRC_URI="https://alpha.gnu.org/gnu/${PN}/${P/_/-}.tar.xz"
	SRC_URI+=" verify-sig? ( https://alpha.gnu.org/gnu/${PN}/${P/_/-}.tar.xz.sig )"
	S="${WORKDIR}/${P/_/-}"
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
	SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${P}.tar.xz.sig )"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
fi
# Only libasprintf is under the LGPL (and libintl is in a sep package),
# so put that license behind USE=cxx.
LICENSE="GPL-3+ cxx? ( LGPL-2.1+ )"
SLOT="0"
IUSE="acl +cxx doc emacs git java ncurses nls openmp static-libs"

# only runtime goes multilib
# Note: The version of libxml2 corresponds to the version bundled via gnulib.
# If the build detects too old of a system version, it will end up falling back
# to the bundled copy.  #596918
# Note: expat lacks a subslot because it is dynamically loaded at runtime.  We
# would depend on older subslots if they were available (based on the ABIs that
# are explicitly handled), but expat doesn't currently use subslots.
DEPEND=">=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	>=virtual/libintl-0-r2[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.3:=
	dev-libs/expat
	acl? ( virtual/acl )
	ncurses? ( sys-libs/ncurses:0= )
	java? ( virtual/jdk:1.8 )"
RDEPEND="${DEPEND}
	git? ( dev-vcs/git )
	java? ( virtual/jre:1.8 )"
BDEPEND="
	git? ( dev-vcs/git )
	verify-sig? ( sec-keys/openpgp-keys-gettext )"
PDEPEND="emacs? ( app-emacs/po-mode )"

MULTILIB_WRAPPED_HEADERS=(
	# only installed for native ABI
	/usr/include/gettext-po.h

	/usr/include/autosprintf.h
	/usr/include/textstyle.h
	/usr/include/textstyle/stdbool.h
	/usr/include/textstyle/version.h
	/usr/include/textstyle/woe32dll.h
)

PATCHES=(
	"${FILESDIR}"/${PN}-0.19.7-disable-libintl.patch #564168
	"${FILESDIR}"/${PN}-0.20-parallel_install.patch #685530
	"${FILESDIR}"/${PN}-0.21_rc1-avoid_eautomake.patch
	"${FILESDIR}"/${PN}-0.21-CVE-2020-12825.patch
	"${FILESDIR}"/${P}-java-autoconf.patch
)

QA_SONAME_NO_SYMLINK=".*/preloadable_libintl.so"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	java-pkg-opt-2_src_prepare

	default

	# gettext-0.21.1-java-autoconf.patch changes
	# gettext-{runtime,tools}/configure.ac and the corresponding
	# configure scripts. Avoid regenerating other autotools output.
	touch -c gettext-{runtime,tools}/{aclocal.m4,Makefile.in,config.h.in,configure} || die

	# Makefile.am adds a dependency on gettext-{runtime,tools}/configure.ac
	touch -c configure || die

	elibtoolize

	if use elibc_musl || use elibc_Darwin; then
		eapply "${FILESDIR}"/${PN}-0.21-musl-omit_setlocale_lock.patch
	fi
}

multilib_src_configure() {
	local myconf=(
		# switches common to runtime and top-level
		--cache-file="${BUILD_DIR}"/config.cache
		#--docdir="\$(datarootdir)/doc/${PF}"

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
		# Never build bundled copy of libxml2.
		--without-included-libxml

		--disable-csharp
		--without-cvs

		$(use_enable acl)
		$(use_enable cxx c++)
		$(use_enable cxx libasprintf)
		$(use_with git)
		$(multilib_native_use_enable java)
		$(use_enable ncurses curses)
		$(use_enable nls)
		$(use_enable openmp)
		$(use_enable static-libs static)
	)

	local ECONF_SOURCE="${S}"
	if ! multilib_is_native_abi ; then
		# for non-native ABIs, we build runtime only
		ECONF_SOURCE+=/gettext-runtime
	fi

	econf "${myconf[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi ; then
		dosym msgfmt /usr/bin/gmsgfmt #43435
		dobin gettext-tools/misc/gettextize
	fi
}

multilib_src_install_all() {
	find "${ED}" -type f -name "*.la" -delete || die

	if use java ; then
		java-pkg_dojar "${ED}"/usr/share/${PN}/*.jar
		rm "${ED}"/usr/share/${PN}/*.jar || die
		rm "${ED}"/usr/share/${PN}/*.class || die
		if use doc ; then
			java-pkg_dojavadoc "${ED}"/usr/share/doc/${PF}/html/javadoc2
		fi
	fi

	dodoc AUTHORS ChangeLog NEWS README THANKS

	if use doc ; then
		docinto html
		dodoc "${ED}"/usr/share/doc/${PF}/*.html
	else
		rm -rf "${ED}"/usr/share/doc/${PF}/{csharpdoc,examples,javadoc2,javadoc1}
	fi
	rm "${ED}"/usr/share/doc/${PF}/*.html || die
}

pkg_preinst() {
	java-pkg-opt-2_pkg_preinst
}
