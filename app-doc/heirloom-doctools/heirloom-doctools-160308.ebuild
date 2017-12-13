EAPI=6

inherit flag-o-matic toolchain-funcs readme.gentoo-r1

DESCRIPTION="Classic Unix documentation tools ported from OpenSolaris"
HOMEPAGE="https://n-t-roff.github.io/heirloom/doctools.html"
SRC_URI="https://github.com/n-t-roff/heirloom-doctools/releases/download/${PV}/${P}.tar.bz2"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cxx"

RDEPEND="!sys-apps/groff"
DEPEND="sys-devel/flex
	virtual/yacc"

src_prepare() {
	# mpm uses C++, we'll build it explicitly if we really want to
	sed -i -e 's:mpm:$(MPM):' makefile || die

	# Fixing compilation issues
	# specific for versions =<160308, fixed in -git
	sed -i -e 's:e.h:e.h y.tab.h:' eqn/eqn.d/Makefile.mk || die
	sed -i -e 's:y.tab.h y.tab.h:y.tab.h:' eqn/eqn.d/Makefile.mk || die

	sed -i -e 's:e.h:e.h y.tab.h:' eqn/neqn.d/Makefile.mk || die
	sed -i -e 's:y.tab.h y.tab.h:y.tab.h:' eqn/neqn.d/Makefile.mk || die

	eapply_user
}

src_configure() {
	append-cppflags -D_GNU_SOURCE

	sed \
		-e "s:@CFLAGS@:${CFLAGS}:" \
		-e "s:@CXXFLAGS@:${CXXFLAGS}:" \
		-e "s:@CPPFLAGS@:${CPPFLAGS}:" \
		-e "s:@LDFLAGS@:${LDFLAGS}:" \
		-e "s:@CC@:$(tc-getCC):" \
		-e "s:@CXX@:$(tc-getCXX):" \
		-e "s:@RANLIB@:$(tc-getRANLIB):" \
		-e "s:@libdir@:$(get_libdir):" \
		"${FILESDIR}"/default.config \
		> "${S}"/mk.config || die
}

src_compile() {
	emake $(echo MPM=$(usex cxx mpm ''))
}

src_install() {
	dodir /usr/share/heirloom/{doc,ref}tools

	# The build system uses the ROOT variable in place of DESTIDR.
	emake $(echo MPM=$(usex cxx mpm '')) ROOT="${D}" install

	dodoc README CHANGES

	# Rename ptx to avoid a collision with coreutils… maybe this
	# should be made conditional to userland_GNU (somebody got to
	# check on FreeBSD).
	mv "${D}"usr/bin/{,hl-}ptx || die
	mv "${D}"usr/share/man/man1/{,hl-}ptx.1 || die

	mv "${D}"usr/bin/{,hl-}col || die

	# Rename ta to avoid a collision with app-cdr/pxlinux
	mv "${D}"usr/bin/{,hl-}ta || die

}

pkg_postinst() {
	local manpkg

	if has_version sys-apps/man; then
    README_GENTOO_SUFFIX="-man" readme.gentoo_print_elog
		manpkg=sys-apps/man
	elif has_version sys-apps/man-db; then
    README_GENTOO_SUFFIX="-mandb" readme.gentoo_print_elog
    manpkg=sys-apps/man-db
  fi

	elog ""
	elog "If you just switched from sys-apps/groff, please make sure to rebuild the"
	elog "${manpkg} package, since there are build-time conditionals on the nroff"
	elog "implementation available."

}
