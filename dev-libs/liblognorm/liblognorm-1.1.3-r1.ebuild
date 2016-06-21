# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Fast samples-based log normalization library"
HOMEPAGE="http://www.liblognorm.com"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="
		git://github.com/rsyslog/${PN}.git
		https://github.com/rsyslog/${PN}.git
	"

	inherit git-r3
else
	SRC_URI="http://www.liblognorm.com/files/download/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~hppa ~x86 ~amd64-linux"
fi

LICENSE="LGPL-2.1"
SLOT="0/2"
IUSE="debug doc static-libs test"

RDEPEND="
	>=dev-libs/libestr-0.1.3
	>=dev-libs/libfastjson-0.99.2:=
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	doc? ( >=dev-python/sphinx-1.2.2 )
"

DOCS=( ChangeLog )

src_prepare() {
	eapply -p0 "${FILESDIR}"/respect_CFLAGS.patch

	default

	eautoreconf
}

src_configure() {
	# regexp disabled due to https://github.com/rsyslog/liblognorm/issues/143
	local myeconfargs=(
		$(use_enable doc docs)
		$(use_enable test testbench)
		$(use_enable debug)
		$(use_enable static-libs static)
		--disable-regexp
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# When adding new tests via patches we have to make them executable
	einfo "Adjusting permissions of test scripts ..."
	find "${S}"/tests -type f -name '*.sh' \! -perm -111 -exec chmod a+x '{}' \; || \
		die "Failed to adjust test scripts permission"

	emake --jobs 1 check
}

src_install() {
	default

	find "${ED}"usr/lib* -name '*.la' -delete || die
}
