# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/backup-manager/backup-manager-0.7.10.1-r2.ebuild,v 1.2 2014/08/10 01:54:00 patrick Exp $

EAPI=5

inherit eutils

MY_P=Backup-Manager-${PV}
DESCRIPTION="Backup Manager is a command line backup tool for GNU/Linux"
HOMEPAGE="http://www.backup-manager.org/"
SRC_URI="http://www.backup-manager.org/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc s3"

DEPEND="dev-lang/perl
	sys-devel/gettext"

RDEPEND="${DEPEND}
	>=sys-apps/findutils-4.3.0
	s3? ( dev-perl/Net-Amazon-S3
		dev-perl/File-Slurp )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i "/^PERL5DIR/s/sitelib/vendorlib/" Makefile \
		|| die "Makefile sed failed"
	sed -i '/^prefix=/s/$(PREFIX)/usr/' po/Makefile \
		|| die "po Makefile sed failed"
	epatch "${FILESDIR}"/${PN}-0.7.9-parallel_install.patch
	epatch "${FILESDIR}"/${PN}-0.7.10-Fix-POD-syntax.patch
}

src_install() {
	emake DESTDIR="${D}" install
	use doc && dodoc doc/user-guide.txt
}

pkg_postinst() {
	elog "After installing,"
	elog "copy ${ROOT%/}/usr/share/backup-manager/backup-manager.conf.tpl to"
	elog "/etc/backup-manager.conf and customize it for your environment."
	elog "You could also set-up your cron for daily or weekly backup."

	ewarn "New configuration keys may have been defined."
	ewarn "Please check the docs for info"
}
