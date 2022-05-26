# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Watches a multilog file for irregularities"
HOMEPAGE="https://www.eyrie.org/~eagle/software/multilog-watch/"
SRC_URI="https://archives.eyrie.org/software/system/multilog-watch"
SRC_URI+=" https://www.eyrie.org/%7Eeagle/software/multilog-watch/sample.filter"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/perl
	virtual/qmail
"

src_unpack() {
	mkdir "${S}" || die
	cp "${DISTDIR}"/multilog-watch "${S}" || die
	cp "${DISTDIR}"/sample.filter "${S}" || die
}

src_compile() {
	mv multilog-watch multilog-watch.orig || die
	sed -e 's/\/etc\/leland/\/etc\/multilog-watch/' multilog-watch.orig > multilog-watch || die
	/usr/bin/pod2man -s 1 multilog-watch multilog-watch.1 || die
}

src_install() {
	insinto /etc/multilog-watch
	doins sample.filter

	dobin multilog-watch
	doman multilog-watch.1
}
