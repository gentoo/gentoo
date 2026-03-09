# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tmpfiles

DESCRIPTION="kernel.org uploader tool"
HOMEPAGE="https://www.kernel.org/pub/software/network/kup"
SRC_URI="https://www.kernel.org/pub/software/network/kup/${P}.tar.xz"

# Debian has sometimes carried useful patches
#DEB_PR=6
#DEB_P=${PN}_${PV}-${DEB_PR}
#SRC_URI+=" mirror://debian/pool/main/${PN::1}/${PN}/${DEB_P}.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gitolite"

RDEPEND="
	app-arch/pigz
	app-arch/xz-utils
	dev-lang/perl
	virtual/perl-Encode
	virtual/perl-File-Spec
	dev-perl/BSD-Resource
	dev-perl/Config-Simple"

DOCS=( README )

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.6-path-lookup-compressor.patch
)

src_prepare() {
	if use gitolite; then
		cp -f "${S}/${PN}-server" "${S}/${PN}-server-gitolite" || die
		patch "${S}/${PN}-server-gitolite" <"${FILESDIR}"/${PN}-server-gitolite-subcmd-r2.patch || die

	fi
	default
}

src_install() {
	dobin "${PN}" "${PN}-server" gpg-sign-all genrings
	doman "${PN}.1" "${PN}-server.1"
	insinto /etc/kup
	doins kup-server.cfg
	einstalldocs
	# Gitolite expects "kup-server" inside the commands directory.
	if use gitolite; then
		exeinto /usr/libexec/gitolite/commands/
		newexe kup-server-gitolite kup-server
		# Gentoo's gitolite fork has a slightly different path:
		exeinto /usr/libexec/gitolite-gentoo/commands/
		dosym -r /usr/libexec/gitolite/commands/kup-server /usr/libexec/gitolite-gentoo/commands/kup-server
	fi
	# Important data kept here
	keepdir /var/lib/kup/pub
	keepdir /var/lib/kup/pgp
	# Will create other directories
	newtmpfiles "${FILESDIR}"/kup.tmpfilesd kup.conf
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}
