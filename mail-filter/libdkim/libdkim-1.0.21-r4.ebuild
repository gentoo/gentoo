# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools toolchain-funcs vcs-clean

DESCRIPTION="DomainKeys Identified Mail library from Alt-N Inc"
HOMEPAGE="http://libdkim.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="Apache-2.0 yahoo-patent-license-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl static-libs"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	!mail-filter/libdkim-exim
"
DEPEND="${RDEPEND}
	app-arch/unzip
"

S="${WORKDIR}/${PN}/src"

src_prepare() {
	default

	ecvs_clean
	cp  "${FILESDIR}"/debianize/* "${S}" || die
	eapply "${FILESDIR}"/patches/*.patch
	eapply "${FILESDIR}"/libdkim-extra-options-r1.patch
	eapply "${FILESDIR}"/${P}-gcc6.patch

	# Bug 476772
	if ! use static-libs; then
		 sed -i \
			-e '/^TARGETS/s/libdkim.a//' \
			-e '/install -m 644 libdkim.a/d' \
			Makefile.in || die 'sed on Makefile.in failed'
	fi

	# Bug 476770
	tc-export AR

	eautoreconf
}

src_install() {
	default
	dodoc ../README
}
