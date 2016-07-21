# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Manage contributed bash-completion scripts"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Eselect"
SRC_URI="mirror://gentoo/eselect-${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris"

RDEPEND=">=app-admin/eselect-1.3.8"

S="${WORKDIR}/eselect-${PV}"

src_prepare() {
	sed -i -e "/^MAINTAINER/aVERSION=\"${PV}\"" modules/bashcomp.eselect || die
}

src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /usr/share/eselect/modules
	doins modules/bashcomp.eselect
	doman man/bashcomp.eselect.5
}
