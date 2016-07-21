# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils pam autotools

MY_P="${P/_beta/beta}"
S="${WORKDIR}/${MY_P}"

PATCHLEVEL="1"
DESCRIPTION="pam module to allow password-storing in \$HOME/dotfiles"
HOMEPAGE="http://0pointer.de/lennart/projects/pam_dotfile/"
SRC_URI="http://0pointer.de/lennart/projects/pam_dotfile/${MY_P}.tar.gz
	http://digilander.libero.it/dgp85/gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"

RDEPEND="virtual/pam"
DEPEND="${RDEPEND}
	doc? ( www-client/lynx )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	EPATCH_SUFFIX="patch" epatch ${WORKDIR}/${PV}

	AT_M4DIR="${WORKDIR}/${PV}/m4" eautoreconf
}

src_compile() {
	local myconf

	econf \
		$(use_enable doc lynx) \
		"--with-pammoddir=$(getpam_mod_dir)" \
		|| die
	emake || die
}

src_install() {
	make -C src DESTDIR="${D}" install || die "make -C src install failed"
	make -C man DESTDIR="${D}" install || die "make -C src install failed"

	rm -f "${D}"/$(getpam_mod_dir)/pam_dotfile.la
	fperms 4111 /usr/sbin/pam-dotfile-helper

	dodoc README
	dohtml doc/*
}
