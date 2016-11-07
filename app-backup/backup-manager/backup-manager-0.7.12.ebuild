# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

MY_P=Backup-Manager-${PV}
DESCRIPTION="Backup Manager is a command line backup tool for GNU/Linux"
HOMEPAGE="https://github.com/sukria/Backup-Manager"
SRC_URI="http://github.com/sukria/Backup-Manager/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="s3"

DEPEND="dev-lang/perl
	sys-devel/gettext"

RDEPEND="${DEPEND}
	s3? ( dev-perl/Net-Amazon-S3
		dev-perl/File-Slurp )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i "/^PERL5DIR/s/sitelib/vendorlib/" Makefile \
		|| die "Makefile sed failed"

	default
}

src_compile() {
	default
	emake -C po
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}

pkg_postinst() {
	elog "After installing,"
	elog "copy ${ROOT%/}/usr/share/backup-manager/backup-manager.conf.tpl to"
	elog "/etc/backup-manager.conf and customize it for your environment."
	elog "You could also set-up your cron for daily or weekly backup."

	ewarn "New configuration keys may have been defined."
	ewarn "Please check the docs for info"
}
