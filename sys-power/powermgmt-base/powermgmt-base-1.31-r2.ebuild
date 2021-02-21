# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Script to test whether computer is running on AC power"
HOMEPAGE="http://packages.debian.org/testing/utils/powermgmt-base"
SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~ia64 ppc ppc64 x86"

RDEPEND="
	virtual/awk
	sys-apps/grep
	sys-apps/kmod[tools]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	sed -i \
		-e 's:$(CC) $(CFLAGS):$(CC) $(LDFLAGS) $(CFLAGS):' \
		src/Makefile || die
}

src_compile() {
	tc-export CC
	emake CFLAGS="${CFLAGS} -Wall -Wstrict-prototypes -DLINUX"
}

src_install() {
	dodir /sbin
	emake DESTDIR="${D}" install

	doman man/{acpi,apm}_available.1

	doman man/on_ac_power.1

	newdoc debian/powermgmt-base.README.Debian README
	dodoc debian/changelog
}
