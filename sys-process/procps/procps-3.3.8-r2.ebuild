# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/procps/procps-3.3.8-r2.ebuild,v 1.5 2015/05/18 11:14:30 vapier Exp $

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="standard informational utilities and process-handling tools"
# http://packages.debian.org/sid/procps
HOMEPAGE="http://procps.sourceforge.net/ https://gitlab.com/procps-ng/procps"
# SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV}.orig.tar.xz"
FEDORA_HASH="aecbeeda2ab308f8d09dddcb4cb9a572"
SRC_URI="http://pkgs.fedoraproject.org/repo/pkgs/${PN}-ng/${PN}-ng-${PV}.tar.xz/${FEDORA_HASH}/${PN}-ng-${PV}.tar.xz
	https://gitorious.org/procps/procps/commit/ce5e995921e770bfcda25e42fe090aeccdbf1291.patch -> ${PN}-3.3.8-respect_epipe_in_fileutils.patch
	https://gitorious.org/procps/procps/commit/e6a78f2745ca6c7ceed4406d3ce5397e77518b11.patch -> ${PN}-3.3.8-top_user_filter.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="+ncurses nls static-libs test unicode"

RDEPEND="ncurses? ( >=sys-libs/ncurses-5.7-r7[unicode?] )"
DEPEND="${RDEPEND}
	ncurses? ( virtual/pkgconfig )
	test? ( dev-util/dejagnu )"

S=${WORKDIR}/${PN}-ng-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-kill-neg-pid.patch \
		"${DISTDIR}"/${P}-respect_epipe_in_fileutils.patch \
		"${DISTDIR}"/${P}-top_user_filter.patch
}

src_configure() {
	econf \
		--exec-prefix="${EPREFIX}" \
		--docdir='$(datarootdir)'/doc/${PF} \
		$(use_with ncurses) \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_enable unicode watch8bit)
}

src_install() {
	default
#	dodoc sysctl.conf

	# The configure script is completely whacked in the head
	mv "${ED}"/lib* "${ED}"/usr/ || die
	gen_usr_ldscript -a procps
	prune_libtool_files
}
