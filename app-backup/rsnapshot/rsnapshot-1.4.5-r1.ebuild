# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A filesystem backup utility based on rsync"
HOMEPAGE="https://www.rsnapshot.org"
SRC_URI="https://www.rsnapshot.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND=">=dev-lang/perl-5.8.2
	dev-perl/Lchown
	>=sys-apps/util-linux-2.12-r4
	>=sys-apps/coreutils-5.0.91-r4
	virtual/openssh
	>=net-misc/rsync-2.6.0"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	# remove '/etc/' since we don't place it here, bug #461554
	sed -i -e 's:/etc/rsnapshot.conf.default:rsnapshot.conf.default:' rsnapshot-program.pl || die
}

src_test() {
	emake test
}

src_install() {
	docompress -x "/usr/share/doc/${PF}/rsnapshot.conf.default"

	# Change sysconfdir to install the template file as documentation
	# rather than in /etc.
	emake install DESTDIR="${D}" \
		sysconfdir="${EPREFIX}/usr/share/doc/${PF}"

	dodoc README.md AUTHORS ChangeLog \
		docs/Upgrading_from_1.1

	docinto utils
	dodoc utils/{README,rsnaptar,*.sh,*.pl}

	docinto utils/rsnapshotdb
	dodoc utils/rsnapshotdb/*
}

pkg_postinst() {
	elog "The template configuration file has been installed as"
	elog "  ${EROOT}/usr/share/doc/${PF}/rsnapshot.conf.default"
	elog "Copy and edit the the above file as ${EROOT}/etc/rsnapshot.conf"
}
