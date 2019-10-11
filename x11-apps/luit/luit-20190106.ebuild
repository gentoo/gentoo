# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Locale and ISO 2022 support for Unicode terminals"
HOMEPAGE="https://invisible-island.net/luit/"
SRC_URI="https://invisible-mirror.net/archives/${PN}/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="sys-libs/zlib
	virtual/libiconv"
RDEPEND="${DEPEND}"
BDEPEND="sys-apps/groff"

src_configure() {
	econf --disable-fontenc --enable-iconv
}
