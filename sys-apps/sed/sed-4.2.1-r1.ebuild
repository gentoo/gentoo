# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sed/sed-4.2.1-r1.ebuild,v 1.14 2014/02/08 13:24:00 vapier Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Super-useful stream editor"
HOMEPAGE="http://sed.sourceforge.net/"
SRC_URI="mirror://gnu/sed/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="acl nls selinux static"

RDEPEND="acl? ( virtual/acl )
	nls? ( virtual/libintl )"
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

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-4.1.5-alloca.patch
	epatch "${FILESDIR}"/${P}-handle-incomplete-sequences-as-if-they-were-invalid.patch #284403
	# don't use sed here if we have to recover a broken host sed
}

src_compile() {
	src_bootstrap_sed
	# this has to be after the bootstrap portion
	sed -i \
		-e '/docdir =/s:=.*/doc:= $(datadir)/doc/'${PF}'/html:' \
		doc/Makefile.in || die "sed html doc"

	local myconf= bindir=/bin
	if ! use userland_GNU ; then
		myconf="--program-prefix=g"
		bindir=/usr/bin
	fi

	export ac_cv_search_setfilecon=$(usex selinux -lselinux)
	export ac_cv_header_selinux_{context,selinux}_h=$(usex selinux)
	use static && append-ldflags -static
	econf \
		--bindir=${bindir} \
		$(use_enable acl) \
		$(use_enable nls) \
		${myconf}
	emake || die "build failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
	dodoc NEWS README* THANKS AUTHORS BUGS ChangeLog
}
