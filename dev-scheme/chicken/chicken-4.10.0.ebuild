# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils multilib versionator

MY_PV=$(get_version_component_range 1-3)
DESCRIPTION="Chicken is a Scheme interpreter and native Scheme to C compiler"
HOMEPAGE="http://www.call-cc.org/"
SRC_URI="http://code.call-cc.org/releases/${MY_PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86"
IUSE="emacs parallel-build doc"

DEPEND="sys-apps/texinfo
		emacs? ( virtual/emacs )"
RDEPEND="emacs? ( virtual/emacs app-emacs/scheme-complete )"

src_prepare() {
	if use "parallel-build"
	then
		epatch "${FILESDIR}"/${PV}-parallel-build.patch
	fi

	#Because chicken's Upstream is in the habit of using variables that
	#portage also uses :( eg. $ARCH and $A
	sed 's,A\(\s?=\|)\),chicken&,' -i Makefile.cross-linux-mingw \
		defaults.make rules.make \
		|| die "sed failed"

	sed "s,ARCH,zARCH," -i Makefile.bsd Makefile.cross-linux-mingw \
		Makefile.cygwin Makefile.haiku Makefile.linux Makefile.macosx \
		Makefile.mingw Makefile.mingw-msys Makefile.solaris \
		defaults.make rules.make \
		|| die "sed failed"

	sed "s,\$(PREFIX)/lib,\$(PREFIX)/$(get_libdir)," -i defaults.make || die "sed failed"
	sed "s,\$(DATADIR)/doc,\$(SHAREDIR)/doc/${P}," -i defaults.make || die "sed failed"
}

src_compile() {
	if use "parallel-build"
	then
		OPTIONS="PLATFORM=linux PREFIX=/usr"
	else
		OPTIONS="-j1 PLATFORM=linux PREFIX=/usr"
	fi

	emake ${OPTIONS} C_COMPILER_OPTIMIZATION_OPTIONS="${CFLAGS}" \
		LINKER_OPTIONS="${LDFLAGS}" \
		HOSTSYSTEM="${CBUILD}"
}

# chicken's testsuite is not runnable before install
# upstream has been notified of the issue
RESTRICT=test

src_install() {
	# still can't run make in parallel for the install target
	emake -j1 ${OPTIONS} DESTDIR="${D}" HOSTSYSTEM="${CBUILD}" \
		LINKER_OPTIONS="${LDFLAGS}" \
		install

	rm "${D}"/usr/share/doc/${P}/LICENSE || die
	dodoc NEWS

	# remove HTML documentation if the user doesn't USE=doc
	if ! use "doc"
	then
		rm -rf "${D}"/usr/share/doc/${P}/manual || die
	fi
}
