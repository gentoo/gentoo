# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/star/star-1.5.2.ebuild,v 1.11 2015/02/22 11:23:01 jlec Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="An enhanced (world's fastest) tar, as well as enhanced mt/rmt"
HOMEPAGE="http://s-tar.sourceforge.net/"
SRC_URI="mirror://sourceforge/s-tar/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1 CDDL-Schily"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="acl xattr"

DEPEND="
	acl? ( sys-apps/acl )
	xattr? ( sys-apps/attr )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/_alpha[0-9][0-9]}

src_prepare() {
	find -type f -exec chmod -c u+w '{}' + || die
	sed \
		-e "s:/opt/schily:${EPREFIX}/usr:g" \
		-e 's:bin:root:g' \
		-e "s:/usr/src/linux/include:${EPREFIX}/usr/include:" \
		-i DEFAULTS/Defaults.linux || die

	# Disable libacl autodependency (hacky build system, hacky fix...)
	if use acl; then
		sed \
			-e 's:[$]ac_cv_header_sys_acl_h:disable acl:' \
			-i "${S}/autoconf/configure" || die
	fi

	if use xattr; then
		sed \
			-e 's:[$]ac_cv_header_attr_xattr_h:disable xattr:' \
			-i "${S}/autoconf/configure" || die
	fi

	# Create additional symlinks needed for some archs.
	pushd "${S}/RULES" > /dev/null
	local t
	for t in ppc64 s390x ; do
		ln -s i586-linux-cc.rul ${t}-linux-cc.rul || die
		ln -s i586-linux-gcc.rul ${t}-linux-gcc.rul || die
	done
	popd > /dev/null

	epatch "${FILESDIR}"/${PN}-1.5.1-changewarnSegv.patch
}

src_configure() { :; } #avoid ./configure run

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		COPTX="${CFLAGS}" \
		CPPOPTX="${CPPFLAGS}" \
		COPTGPROF= \
		COPTOPT= \
		LDOPTX="${LDFLAGS}"
}

src_install() {
	# Joerg Schilling suggested to integrate star into the main OS using call:
	# make INS_BASE=/usr DESTDIR="${D}" install

	dobin \
		star/OBJ/*-*-cc/star \
		tartest/OBJ/*-*-cc/tartest \
		star_sym/OBJ/*-*-cc/star_sym \
		mt/OBJ/*-*-cc/smt

	newsbin rmt/OBJ/*-*-cc/rmt rmt.star
	newman rmt/rmt.1 rmt.star.1

	# Note that we should never install gnutar, tar or rmt in this package.
	# tar and rmt are provided by app-arch/tar. gnutar is not compatible with
	# GNU tar and breakes compilation, or init scripts. bug #33119
	dosym {star,/usr/bin/ustar}
	dosym {star,/usr/bin/spax}
	dosym {star,/usr/bin/scpio}
	dosym {star,/usr/bin/suntar}

	#  match is needed to understand the pattern matcher, if you wondered why ;)
	doman man/man1/match.1 tartest/tartest.1 \
		star/{star.4,star.1,spax.1,scpio.1,suntar.1}

	insinto /etc/default
	newins star/star.dfl star
	newins rmt/rmt.dfl rmt

	dodoc star/{README.ACL,README.crash,README.largefiles,README.otherbugs} \
		star/{README.pattern,README.pax,README.posix-2001,README,STARvsGNUTAR} \
			rmt/default-rmt.sample TODO AN-* Changelog CONTRIBUTING
}
