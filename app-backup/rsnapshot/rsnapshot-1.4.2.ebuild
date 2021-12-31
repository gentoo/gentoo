# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A filesystem backup utility based on rsync"
HOMEPAGE="http://www.rsnapshot.org"
SRC_URI="http://www.rsnapshot.org/downloads/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"

RDEPEND=">=dev-lang/perl-5.8.2
		dev-perl/Lchown
		>=sys-apps/util-linux-2.12-r4
		>=sys-apps/coreutils-5.0.91-r4
		>=net-misc/openssh-3.7.1_p2-r1
		>=net-misc/rsync-2.6.0"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	# remove '/etc/' since we don't place it here, bug #461554
	sed -i -e 's:/etc/rsnapshot.conf.default:rsnapshot.conf.default:' rsnapshot-program.pl || die
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
	elog "  /usr/share/doc/${PF}/rsnapshot.conf.default"
	elog "Copy and edit the the above file as /etc/rsnapshot.conf"
}
