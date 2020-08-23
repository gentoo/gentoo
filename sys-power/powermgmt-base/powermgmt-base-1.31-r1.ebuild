# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Script to test whether computer is running on AC power"
HOMEPAGE="http://packages.debian.org/testing/utils/powermgmt-base"
SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~ia64 ppc ppc64 x86"
IUSE="+pm-utils"

RDEPEND="!pm-utils? ( virtual/awk )
	sys-apps/grep
	sys-apps/kmod[tools]
	pm-utils? ( >=sys-power/pm-utils-1.4.1 )"

S=${WORKDIR}/${PN}

src_prepare() {
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

	if ! use pm-utils; then
		doman man/on_ac_power.1
	else
		rm -f "${D}"/sbin/on_ac_power
	fi

	newdoc debian/powermgmt-base.README.Debian README
	dodoc debian/changelog
}
