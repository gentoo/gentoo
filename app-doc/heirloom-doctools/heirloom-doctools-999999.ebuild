EAPI=6

inherit git-r3 flag-o-matic toolchain-funcs multilib

DESCRIPTION="Classic Unix documentation tools ported from OpenSolaris"
HOMEPAGE="https://n-t-roff.github.io/heirloom/doctools.html"
EGIT_REPO_URI="git://github.com/n-t-roff/heirloom-doctools.git"

LICENSE="CDDL"
SLOT="0"
IUSE="cxx"

RDEPEND="!sys-apps/groff"
DEPEND="sys-devel/flex
	virtual/yacc"

src_prepare() {
	# mpm uses C++, we'll build it explicitly if we really want to
	sed -i -e 's:mpm:$(MPM):' makefile || die

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
		"${FILESDIR}"/${PV}.config \
		> "${S}"/mk.config
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
		elog "To make proper use of heirloom-doctools with sys-apps/man you"
		elog "need to make sure that /etc/man.conf is configured properly with"
		elog "the following settings:"
		elog ""
		elog "TROFF           /usr/bin/troff -Tlocale -mg -msafe -mpadj -mandoc"
		elog "NROFF           /usr/bin/nroff -mg -msafe -mpadj -mandoc"
		elog "EQN             /usr/bin/eqn -Tps"
		elog "NEQN            /usr/bin/neqn -Tlatin1"
		elog "TBL             /usr/bin/tbl"
		elog "COL             /usr/bin/hl-col"
		elog "REFER           /usr/bin/refer"
		elog "PIC             /usr/bin/pic"
		elog "VGRIND          /usr/bin/vgrind"
		elog "GRAP            /usr/bin/grap"
		manpkg=sys-apps/man
	elif has_version sys-apps/man-db; then
		elog "To make proper use of heirloom-doctools with sys-apps/man you"
		elog "need to make sure that /etc/man_db.conf is configured properly with"
		elog "the following settings:"
		elog ""
		elog "DEFINE  troff   troff -Tlocale -mg -msafe -mpadj -mandoc"
		elog "DEFINE  nroff   nroff -mg -msafe -mpadj -mandoc"
		elog "DEFINE  eqn     eqn -Tps"
		elog "DEFINE  neqn    neqn -Tlatin1"
		elog "DEFINE  tbl     tbl"
		elog "DEFINE  col     hl-col"
		elog "DEFINE  vgrind  vgrind"
		elog "DEFINE  refer   refer"
		elog "DEFINE  grap    grap"
		elog "DEFINE  pic     pic"
		elog
		ewarn "The compatibility between heirloom-doctools and man-db is pretty limited"
		ewarn "you've been warned. Your man pages might look nothing like you were used"
		ewarn "to."
		manpkg=sys-apps/man-db
	fi
	elog ""
	elog "If you just switched from sys-apps/groff, please make sure to rebuild the"
	elog "${manpkg} package, since there are build-time conditionals on the nroff"
	elog "implementation available."
}
