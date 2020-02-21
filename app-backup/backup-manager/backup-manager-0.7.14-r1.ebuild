# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils

MY_P=Backup-Manager-${PV}
DESCRIPTION="Backup Manager is a command line backup tool for GNU/Linux"
HOMEPAGE="https://github.com/sukria/Backup-Manager"
SRC_URI="https://github.com/sukria/Backup-Manager/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="s3"

DEPEND="dev-lang/perl:=
	sys-devel/gettext"

RDEPEND="${DEPEND}
	s3? ( dev-perl/Net-Amazon-S3
		dev-perl/File-Slurp )"

PATCHES=( "${FILESDIR}"/${P}-fix_purge.patch )

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -e "/^PERL5DIR/s/sitelib/vendorlib/" \
		-e "/sed/s:=\$(DESTDIR)/:=:" \
		-i Makefile || die

	default
}

src_compile() {
	default
	emake -C po
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install

	insinto /etc
	newins backup-manager.conf.tpl backup-manager.conf
	fperms 0600 /etc/backup-manager.conf
}
