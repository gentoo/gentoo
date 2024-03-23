# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="IPv6 diagnostic tools"
HOMEPAGE="https://www.remlab.net/ndisc6/"
SRC_URI="https://www.remlab.net/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86 ~x64-macos"
IUSE="debug"

BDEPEND="
	dev-lang/perl
	sys-devel/gettext
"

src_configure() {
	local args=(
		--localstatedir="${EPREFIX}"/var
		$(use_enable debug assert)
	)
	econf "${args[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	rm -r "${ED}/var" || die

	newinitd "${FILESDIR}"/rdnssd.rc-2 rdnssd
	newconfd "${FILESDIR}"/rdnssd.conf rdnssd

	exeinto /etc/rdnssd
	newexe "${FILESDIR}"/resolvconf-2 resolvconf
	dodoc AUTHORS ChangeLog NEWS README
}
