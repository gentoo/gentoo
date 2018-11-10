# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="lib that implements the client side of the SMTP protocol"
HOMEPAGE="http://brianstafford.info/libesmtp/"
SRC_URI="http://brianstafford.info/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="debug libressl ntlm ssl static-libs threads"

RDEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)"
DEPEND="${RDEPEND}"
DOCS=( AUTHORS ChangeLog NEWS Notes README TODO )
PATCHES=(
	"${FILESDIR}/${P}-openssl-1.1-api-compatibility.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		--enable-all \
		$(use_enable ntlm) \
		$(use_enable threads pthreads) \
		$(use_enable debug) \
		$(use_with ssl openssl)
}

src_install() {
	default
	insinto /usr/share/doc/${PF}/xml
	doins doc/api.xml
}
