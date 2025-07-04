# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="GnuPG archive keys of the Debian archive"
HOMEPAGE="https://packages.debian.org/sid/debian-archive-keyring"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}_all.deb"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~x86"

src_install() {
	doins -r .

	# https://bugs.gentoo.org/729142
	gunzip "${D}"/usr/share/doc/${PN}/changelog.gz || die
	gunzip "${D}"/usr/share/doc/${PN}/NEWS.Debian.gz || die

	mv "${D}"/usr/share/doc/{${PN},${PF}} || die
}
