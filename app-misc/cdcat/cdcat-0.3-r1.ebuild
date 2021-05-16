# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple yet effective CD indexing program"
# original src went away: SRC_URI="http://littledragon.home.ro/unix/${P}.tar.gz"
SRC_URI="mirror://sourceforge/cdcatalog/${P}.tar.gz"
HOMEPAGE="http://cdcatalog.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="app-cdr/cdrtools
	!app-backup/cdbkup"

src_prepare() {
	default
	# workaround install.sh ignoring --man_prefix
	sed -i 's:^MAN_PREFIX:#:' install.sh || die

	# fix path to cd index files to be FHS-compliant
	sed -i 's:/mnt/ext/cd:/var/lib/cdcat:' src/cdcat.pl || die

	# work around problem with isoinfo -di
	sed -i 's:isoinfo -di:isoinfo -d -i:' src/cdcat.pl || die
}

src_install() {
	# workaround install.sh ignoring --man_prefix
	export MAN_PREFIX="${D}/usr/share/man"
	dodir /usr/share/man/man1

	# create index files path
	dodir /var/lib/cdcat
	keepdir /var/lib/cdcat
	chgrp cdrom "${D}"/var/lib/cdcat
	chmod g+ws,o+w "${D}"/var/lib/cdcat || die

	# now use the included install.sh
	./install.sh --prefix="${D}/usr" \
		--man_prefix="${D}/usr/share/man" || die "Install script failed."

	insinto /etc
	doins doc/cdcat.conf
}
