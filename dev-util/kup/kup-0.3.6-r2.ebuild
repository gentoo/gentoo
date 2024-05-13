# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="kernel.org uploader tool"
HOMEPAGE="https://www.kernel.org/pub/software/network/kup"
SRC_URI="https://www.kernel.org/pub/software/network/kup/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/perl
	dev-perl/BSD-Resource
	dev-perl/Config-Simple"
IUSE='gitolite'

DOCS=( README )

src_prepare() {
	if use gitolite; then
		cp -f "${S}/${PN}-server" "${S}/${PN}-server-gitolite"
		patch "${S}/${PN}-server-gitolite" <"${FILESDIR}"/${PN}-server-gitolite-subcmd.patch || die
	fi
	default
}

src_install() {
	dobin "${PN}" "${PN}-server" gpg-sign-all genrings
	doman "${PN}.1" "${PN}-server.1"
	insinto /etc/kup
	doins kup-server.cfg
	einstalldocs
	if use gitolite; then
		exeinto /usr/libexec/gitolite/commands/
		newexe ${PN}-server-gitolite ${PN}-server
	fi
}
