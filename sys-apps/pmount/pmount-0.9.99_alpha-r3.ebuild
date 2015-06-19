# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pmount/pmount-0.9.99_alpha-r3.ebuild,v 1.10 2014/03/19 15:18:45 ago Exp $

EAPI=5
inherit eutils user

DESCRIPTION="Policy based mounter that gives the ability to mount removable devices as a user"
HOMEPAGE="http://pmount.alioth.debian.org/"
SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV/_/-}.orig.tar.bz2"
#SRC_URI="http://alioth.debian.org/frs/download.php/3530/${P/_/-}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86"
IUSE="crypt"

RDEPEND=">=sys-apps/util-linux-2.17.2
	crypt? ( >=sys-fs/cryptsetup-1.0.6-r2 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext"

S=${WORKDIR}/${P/_/-}

pkg_setup() {
	enewgroup plugdev
}

src_prepare() {
	# Restore default value from pmount <= 0.9.23 wrt #393633
	sed -i -e '/^not_physically_logged_allow/s:=.*:= yes:' etc/pmount.conf || die

	cat <<-EOF > po/POTFILES.skip
	src/conffile.c
	src/configuration.c
	src/loop.c
	EOF

	epatch \
		"${FILESDIR}"/${PN}-0.9.19-testsuite-missing-dir.patch \
		"${FILESDIR}"/${P}-locale-regex.patch
}

src_configure() {
	econf --disable-hal
}

src_test() {
	local testdir=${S}/tests/check_fstab

	ln -s $testdir/a $testdir/b && ln -s $testdir/d $testdir/c && \
		ln -s $testdir/c $testdir/e \
		|| die "Unable to create fake symlinks required for testsuite"

	emake check
}

src_install () {
	# Must be run SETUID+SETGID, bug #250106
	exeinto /usr/bin
	exeopts -m 6710 -g plugdev
	doexe src/{p,pu}mount

	dodoc AUTHORS ChangeLog TODO
	doman man/{{p,pu}mount.1,pmount.conf.5}

	insinto /etc
	doins etc/pmount.{allow,conf}

	keepdir /media #501772
}

pkg_postinst() {
	elog
	elog "This package has been installed setuid and setgid."

	elog "The permissions are as such that only users that belong to the plugdev"
	elog "group are allowed to run this. But if a script run by root mounts a"
	elog "device, members of the plugdev group will have access to it."
	elog
	elog "Please add your user to the plugdev group to be able to mount USB drives"
}
