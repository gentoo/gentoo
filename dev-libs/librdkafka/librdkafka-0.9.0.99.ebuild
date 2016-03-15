# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Apache Kafka C/C++ client library"
HOMEPAGE="https://github.com/edenhill/librdkafka"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="
		git://github.com/edenhill/${PN}.git
		https://github.com/edenhill/${PN}.git
		"

	inherit git-r3
else
	SRC_URI="https://github.com/edenhill/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-2"

# subslot = soname version
SLOT="0/1"

IUSE="sasl ssl static-libs"

RDEPEND="
	sasl? ( dev-libs/cyrus-sasl:= )
	ssl? ( dev-libs/openssl:0= )
	sys-libs/zlib
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	local myeconf=(
		--no-cache
		--no-download
		$(use_enable sasl)
		$(usex static-libs '--enable-static' '')
		$(use_enable ssl)
	)

	econf ${myeconf[@]}
}

src_test() {
	emake -C tests run_local
}

src_install() {
	local DOCS=(
		README.md
		CONFIGURATION.md
		INTRODUCTION.md
	)

	default

	if ! use static-libs; then
		find "${ED}"usr/lib* -name '*.la' -o -name '*.a' -delete || die
	fi
}
