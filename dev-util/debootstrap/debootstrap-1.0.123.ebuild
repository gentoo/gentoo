# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Debian/Ubuntu bootstrap scripts"
HOMEPAGE="https://packages.qa.debian.org/d/debootstrap.html"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.gz
	mirror://gentoo/devices.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	app-arch/dpkg
	net-misc/wget
	sys-devel/binutils
"
DOCS=( TODO debian/changelog )
S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${PN}_${PV}.tar.gz
	cp "${DISTDIR}"/devices.tar.gz "${S}"
}

src_compile() {
	return
}

src_install() {
	default
	doman debootstrap.8
}

pkg_postinst() {
	if ! has_version ${CATEGORY}/${PN} && ! has_version app-crypt/gnupg; then
		elog "To check Release files against a keyring (--keyring=K), please"
		elog "install app-crypt/gnupg"
	fi

	if ! has_version app-crypt/debian-archive-keyring || ! has_version app-crypt/ubuntu-keyring; then
		elog "To check Release files from Debian or Ubuntu, please install"
		elog " app-crypt/debian-archive-keyring or"
		elog " app-crypt/ubuntu-keyring as required"
	fi
}
