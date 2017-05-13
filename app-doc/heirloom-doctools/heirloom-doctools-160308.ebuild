# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/heirloom-doctools/Attic/heirloom-doctools-080407-r2.ebuild,v 1.3 2011/01/20 04:42:43 flameeyes dead $
# revived from n-t-roff github fork.

EAPI=6

inherit flag-o-matic toolchain-funcs multilib

DESCRIPTION="Classic Unix documentation tools ported from OpenSolaris"
HOMEPAGE="http://heirloom.sourceforge.net/doctools.html"
SRC_URI="https://github.com/n-t-roff/heirloom-doctools/releases/download/${PV}/${P}.tar.bz2"

LICENSE="CDDL"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="cxx"

RDEPEND="!sys-apps/groff"
DEPEND="sys-devel/flex
	virtual/yacc"

src_prepare() {
	# Make sure that C++ code is built with CXXFLAGS and not CFLAGS.
	find . -name Makefile.mk -exec \
		sed -i \
			-e '/(CCC)/s:CFLAGS:CXXFLAGS:' \
		{} +

	# mpm uses C++, we'll build it explicitly if we really want to
	sed -i -e 's:mpm:$(MPM):' makefile

	# Monkeypatching dependencies to avoid parallel make failure
	echo "picl.o: picl.c y.tab.h" >> pic/Makefile.mk

    # Fixing compilation issues
	sed -i -e 's:e.h:e.h y.tab.h:' eqn/eqn.d/Makefile.mk
	sed -i -e 's:y.tab.h y.tab.h:y.tab.h:' eqn/eqn.d/Makefile.mk

    sed -i -e 's:e.h:e.h y.tab.h:' eqn/neqn.d/Makefile.mk
	sed -i -e 's:y.tab.h y.tab.h:y.tab.h:' eqn/neqn.d/Makefile.mk

	# Move some stuff around to better suit our filesystem layout
    sed -i -e '/INSTALL.*grap\.defines/s:$(LIBDIR):/usr/share/heirloom/doctools:' \
		grap/Makefile.mk || die
	sed -i -e '/GRAPDEFINES/s:LIBDIR:"/usr/share/heirloom/doctools":' \
		grap/main.c || die

	sed -i -e '/INSTALL.*eign/s:$(LIBDIR):/usr/share/heirloom/doctools:' \
		ptx/Makefile.mk || die
	sed -i -e '/\/eign/s:\(LIB\|REF\)DIR:"/usr/share/heirloom/doctools":' \
		ptx/ptx.c refer/mkey3.c || die

	sed -i -e 's:$(LIBDIR)/vgrindefs:/usr/share/heirloom/doctools/vgrindefs:' \
		vgrind/Makefile.mk || die
	sed -i -e '/\/vgrindefs/s:LIBDIR:"/usr/share/heirloom/doctools":' \
		vgrind/vfontedpr.c || die

	sed -i -e 's:$(REFDIR)/papers:/usr/share/heirloom/reftools/papers:g' \
		refer/Makefile.mk || die
	sed -i -e '/\/papers\/Ind/s:REFDIR:"/usr/share/heirloom/reftools":' \
		refer/refer1.c || die

	# Correct paths for the installed man pages, just to be clean
	find . \( -name '*.1' -or -name '*.1b' -or -name '*.7' -or -name '*.7b' \) -exec \
		sed -i \
			-e "s:/usr/ucblib/grap.defines:/usr/share/heirloom/doctools/grap.defines:" \
			-e "s:/usr/ucblib/vgrindefs:/usr/share/heirloom/doctools/vgrindefs:" \
			-e "s:/usr/ucblib/vfontedpr:/usr/libexec/heirloom/doctools/vfontedpr:" \
			-e "s:/usr/ucblib/tmac/vgrind:/usr/share/heirloom/tmac/vgrind:" \
			-e "s:/usr/ucblib/eign:/usr/share/heirloom/doctools/eign:" \
			-e "s:/usr/ucb/:/usr/bin/:g" \
			-e "s:/usr/ucblib/doctools:/usr/share/heirloom/doctools:g" \
			-e "s:/usr/ucblib/reftools/papers:/usr/share/heirloom/reftools/papers:" \
			-e "s:/usr/ucblib/reftools:/usr/libexec/heirloom/reftools:g" \
		{} +

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
	emake $(use cxx && echo MPM=mpm) \
	BINDIR="/usr/bin" \
	LIBDIR="/usr/share/heirloom/doctools" \
	PUBDIR="/usr/share/heirloom/doctools/pub" \
	MANDIR="/usr/share/man" \
	MACDIR="/usr/share/heirloom/doctools/tmac" \
	FNTDIR="/usr/share/heirloom/doctools/font" \
	PSTDIR="/usr/share/heirloom/doctools/font/devpost/postscript" \
	TABDIR="/usr/share/heirloom/doctools/nterm" \
	HYPDIR="/usr/share/heirloom/doctools/hyphen" \
	REFDIR="/usr/share/heirloom/reftools" \
	|| die
}

src_install() {
	dodir /usr/share/heirloom/{doc,ref}tools

	# The build system uses the ROOT variable in place of DESTIDR.
	emake $(use cxx && echo MPM=mpm) INSTALL="/usr/bin/install" STRIP="/usr/bin/strip" \
    BINDIR="/usr/bin" \
	LIBDIR="/usr/share/heirloom/doctools" \
	PUBDIR="/usr/share/heirloom/doctools/pub" \
	MANDIR="/usr/share/man" \
	MACDIR="/usr/share/heirloom/doctools/tmac" \
	FNTDIR="/usr/share/heirloom/doctools/font" \
	PSTDIR="/usr/share/heirloom/doctools/font/devpost/postscript" \
	TABDIR="/usr/share/heirloom/doctools/nterm" \
	HYPDIR="/usr/share/heirloom/doctools/hyphen" \
	REFDIR="/usr/share/heirloom/reftools" \
	ROOT="${D}" install || die

	dodoc README CHANGES || die

	# Rename ptx to avoid a collision with coreutils… maybe this
	# should be made conditional to userland_GNU (somebody got to
	# check on FreeBSD).
	mv "${D}"usr/bin/{,hl-}ptx || die
	mv "${D}"/usr/share/man/man1/{,hl-}ptx.1 || die

    mv "${D}"usr/bin/{,hl-}col || die

	# Rename ta to avoid a collision with app-cdr/pxlinux
	mv "${D}"usr/bin/{,hl-}ta || die

	# Not sure why they install in man{1,7}b, but we don't list that
	# in by default, so move all of them to man1. We don't do that in
	# the Makefiles, because it's definitely more complex (even though
	# faster).
	pushd "${D}"/usr/share/man
	for section in 1 7; do
		for man in man${section}b/*.${section}b*; do
			if [ -L $man ]; then
				local oldlink=$(readlink $man)
				rm $man
				ln -s ${oldlink//${section}b/${section}} ${man//${section}b/${section}}
			else
				mv -f $man ${man//${section}b/${section}} || echo "failed moving $man"
			fi
		done
	done
	rmdir man{1,7}b
	popd

	# Add some compatibility encodings for being able to use heirloom-doctools with
	# sys-apps/man-db
	for encoding in utf8 ascii; do
		ln -s tab.37 "${D}"/usr/share/heirloom/nterm/tab.${encoding}
	done
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
