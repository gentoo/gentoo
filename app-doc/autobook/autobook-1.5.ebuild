# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GNU Autoconf, Automake and Libtool"
HOMEPAGE="https://sourceware.org/autobook/"
SRC_URI="
	https://sourceware.org/autobook/${P}.tar.gz
	https://sourceware.org/autobook/foonly-2.0.tar.gz
	https://sourceware.org/autobook/small-2.0.tar.gz
	https://sourceware.org/autobook/hello-2.0.tar.gz
	https://sourceware.org/autobook/convenience-2.0.tar.gz"

LICENSE="OPL"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 m68k ppc s390 sh x86"

src_install() {
	local HTML_DOCS=( . )
	einstalldocs

	local d
	for d in {convenience,foonly,hello,small}-2.0; do
		dodoc -r "${WORKDIR}"/${d}
	done
}
