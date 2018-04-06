# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit pax-utils systemd readme.gentoo-r1 versionator

DESCRIPTION="The Great Internet Mersenne Prime Search"
HOMEPAGE="https://www.mersenne.org/"

# The author has finally caved in to the pressure of putting the build
# number in the package name. Some dark magic necessary to get to the
# package name

MY_PV=$(replace_version_separator 2 'b' )

SRC_URI="
	amd64? ( ftp://mersenne.org/gimps/p95v${MY_PV/./}.linux64.tar.gz )"

SLOT="0"
LICENSE="GIMPS"
KEYWORDS="-* amd64"

# Since there are no statically linked binaries for this version of mprime,
# and no static binaries for amd64 in general, we use the dynamically linked
# ones and try to cover the .so deps with the packages listed in RDEPEND.
# libgmp.so.10.3.2 is bundled within the .tar.gz, but we use the system one.

DEPEND=""
RDEPEND="net-misc/curl
	>=dev-libs/gmp-6.1.2"

S="${WORKDIR}"
I="/opt/gimps"

QA_PREBUILT="opt/gimps/mprime"

DOCS=( license.txt readme.txt stress.txt whatsnew.txt undoc.txt )

src_install() {
	dodir ${I} /var/lib/gimps
	pax-mark m mprime
	cp mprime "${D}/${I}" || die
	fperms a-w "${I}/mprime"
	fowners root:0 "${I}"
	fowners root:0 "${I}/mprime"

	einstalldocs

	readme.gentoo_create_doc

	newinitd "${FILESDIR}/${PN}-28.9-init.d" gimps
	newconfd "${FILESDIR}/${PN}-25.6-conf.d" gimps

	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newtmpfilesd "${FILESDIR}/${PN}.tmpfiles" "${PN}.conf"
}

pkg_postinst() {
	readme.gentoo_print_elog
}

pkg_postrm() {
	echo
	einfo "GIMPS data files were not removed."
	einfo "Remove them manually from /var/lib/gimps/"
	echo
}
