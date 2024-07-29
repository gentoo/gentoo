# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV/_p/+nmu}"

DESCRIPTION="Debian/Ubuntu bootstrap scripts"
HOMEPAGE="https://packages.qa.debian.org/d/debootstrap.html"
SRC_URI="https://salsa.debian.org/installer-team/${PN}/-/archive/${MY_PV}/${PN}-${MY_PV}.tar.bz2
	mirror://gentoo/devices.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	app-arch/dpkg
	net-misc/wget
	sys-devel/binutils
"

S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	unpack "${PN}-${MY_PV}".tar.bz2
	cp "${DISTDIR}"/devices.tar.gz "${S}" || die
}

src_compile() {
	:
}

src_install() {
	local DOCS=( TODO debian/changelog )
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
