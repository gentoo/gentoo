# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="A reliable, thread safe, clear-model, pure C logging library."
HOMEPAGE="http://hardysimpson.github.io/zlog/"
SRC_URI="https://github.com/HardySimpson/${PN}/archive/${PV}.tar.gz -> ${PN}-v${PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	default_src_prepare
	epatch "${FILESDIR}/zlog_no_werr.patch"
}

src_test () {
	emake test
}

src_install() {
	emake PREFIX="${D}/usr" install
}
