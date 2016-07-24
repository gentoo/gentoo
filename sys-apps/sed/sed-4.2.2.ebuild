# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Super-useful stream editor"
HOMEPAGE="http://sed.sourceforge.net/"
SRC_URI="mirror://gnu/sed/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="acl nls selinux static"

RDEPEND="acl? ( virtual/acl )
	nls? ( virtual/libintl )
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_bootstrap_sed() {
	# make sure system-sed works #40786
	export NO_SYS_SED=""
	if ! type -p sed > /dev/null ; then
		NO_SYS_SED="!!!"
		./bootstrap.sh || die "couldnt bootstrap"
		cp sed/sed "${T}"/ || die "couldnt copy"
		export PATH="${PATH}:${T}"
		make clean || die "couldnt clean"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.1.5-alloca.patch

	# don't use sed before bootstrap if we have to recover a broken host sed
	src_bootstrap_sed
	# this has to be after the bootstrap portion
	sed -i \
		-e '/docdir =/s:=.*/doc:= $(datadir)/doc/'${PF}'/html:' \
		doc/Makefile.in || die "sed html doc"
}

src_configure() {
	local myconf=()
	if use userland_GNU; then
		myconf+=( --exec-prefix="${EPREFIX}" )
	else
		myconf+=( --program-prefix=g )
	fi

	# Should be able to drop this hack in next release. #333887
	tc-is-cross-compiler && export gl_cv_func_working_acl_get_file=yes
	export ac_cv_search_setfilecon=$(usex selinux -lselinux)
	export ac_cv_header_selinux_{context,selinux}_h=$(usex selinux)
	use static && append-ldflags -static
	econf \
		$(use_enable acl) \
		$(use_enable nls) \
		"${myconf[@]}"
}
