# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Save environment variables in a secret vault"
HOMEPAGE="https://github.com/sorah/envchain"
SRC_URI="https://github.com/sorah/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	sys-libs/readline:0=
	app-crypt/libsecret"

RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}/usr" install
}
