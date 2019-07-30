# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

DESCRIPTION="A network interface to Tokyo Cabinet"
HOMEPAGE="https://fallabs.com/tokyotyrant/"
SRC_URI="https://fallabs.com/tokyotyrant/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86 ~ppc-macos ~x86-macos"
IUSE="debug examples lua"

DEPEND="dev-db/tokyocabinet
	sys-libs/zlib
	lua? ( dev-lang/lua )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use !prefix ; then
		enewgroup tyrant
		enewuser tyrant -1 -1 /var/lib/${PN} tyrant
	fi
}

src_prepare() {
	default
	eapply "${FILESDIR}"/fix_makefiles-1.4.41.patch
	eapply "${FILESDIR}"/fix_testsuite.patch
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable lua)
}

src_install() {
	rm ttservctl || die "Install failed"
	default

	for x in /var/{lib,run,log}/${PN}; do
		dodir "${x}" || die "Install failed"
		use prefix || fowners tyrant:tyrant "${x}"
	done

	if use examples; then
		insinto /usr/share/${PF}/example
		doins -r example/
	fi

	dodoc -r doc

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

}

src_test() {
	emake -j1 check
}
