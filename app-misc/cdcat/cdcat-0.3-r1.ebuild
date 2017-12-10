# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="simple yet effective CD indexing program"
# original src went away: SRC_URI="http://littledragon.home.ro/unix/${P}.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"
HOMEPAGE="https://web.archive.org/web/20070925183735/http://dev.gentoo.org:80/~centic/cdcat/page1.html#link0"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="virtual/cdrtools
	!app-backup/cdbkup"

src_prepare() {
	unpack ${A}
	cd "${S}"

	# workaround install.sh ignoring --man_prefix
	sed -i 's:^MAN_PREFIX:#:' install.sh

	# fix path to cd index files to be FHS-compliant
	sed -i 's:/mnt/ext/cd:/var/lib/cdcat:' src/cdcat.pl

	# work around problem with isoinfo -di
	sed -i 's:isoinfo -di:isoinfo -d -i:' src/cdcat.pl
}

src_install() {
	# workaround install.sh ignoring --man_prefix
	export MAN_PREFIX="${D}/usr/share/man"
	dodir /usr/share/man/man1

	# create index files path
	dodir          /var/lib/cdcat
	chgrp cdrom    "${D}"/var/lib/cdcat
	chmod g+ws,o+w "${D}"/var/lib/cdcat

	# now use the included install.sh
	./install.sh --prefix="${D}/usr" \
		--man_prefix="${D}/usr/share/man" || die "Install script failed."

	insinto /etc
	doins doc/cdcat.conf || die
}
