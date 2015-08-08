# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils autotools

DESCRIPTION="Fedora bootstrap scripts"
HOMEPAGE="http://people.redhat.com/~rjones/febootstrap/"
SRC_URI="http://people.redhat.com/~rjones/febootstrap/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sys-apps/fakeroot-1.11
	>=sys-apps/fakechroot-2.9
	dev-lang/perl
	>=sys-apps/yum-3.2.21
	sys-fs/e2fsprogs
	sys-libs/e2fsprogs-libs"
RDEPEND="${DEPEND}"
QA_EXECSTACK="usr/bin/febootstrap-supermin-helper"

src_prepare() {
	# https://lists.gnu.org/archive/html/grub-devel/2012-07/msg00051.html
	sed -i -e '/gets is a security/d' lib/stdio.in.h
	epatch "${FILESDIR}"/remove_all-static.patch

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc TODO README examples/*.sh || die
}
