# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd

DESCRIPTION="Daemon for communication with eBUS heating systems"
HOMEPAGE="
	https://ebusd.de
	https://github.com/john30/ebusd
"
SRC_URI="https://github.com/john30/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+contrib doc knx mqtt +ssl test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/openssl:0=
	mqtt? ( app-misc/mosquitto )
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-23.3-gentoo.patch"
	"${FILESDIR}/${PN}-23.3-htmlpath.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# KNXd is currently not packaged in Gentoo
	local myeconfargs=(
		$(use_with contrib)
		$(usex doc '--with-docs' '')
		$(use_with knx)
		$(use_with mqtt)
		$(use_with ssl)

		--localstatedir="${EPREFIX}/var"
		--without-knxd
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	if use test; then
		pushd src/lib/ebus/test || die
			emake
		popd || die

		if use contrib; then
			pushd src/lib/ebus/contrib/test || die
				emake
			popd || die
		fi
	fi
}

src_test() {
	pushd src/lib/ebus/test || die
		./test_filereader >/dev/null && \
		./test_data >/dev/null && \
		./test_message >/dev/null && \
		./test_symbol >/dev/null && \
		einfo "standard: OK!" || die
	popd || die

	if use contrib; then
		pushd src/lib/ebus/contrib/test || die
			./test_contrib >/dev/null && einfo "contrib: OK!" || die
		popd || die
	fi
}

src_install() {
	default
	use doc && dodoc -r docs/html
	newinitd "${FILESDIR}"/ebusd.initd-r1 ebusd
	newconfd "${FILESDIR}"/ebusd.confd ebusd
	systemd_newunit "${FILESDIR}"/ebusd.service-r1 ebusd.service
}
