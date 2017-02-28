# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

MY_PN=h323plus-app
MY_PV=1_23_0
DESCRIPTION="Simple Multi Conference Unit using H.323"
HOMEPAGE="http://www.h323plus.org/"
SRC_URI="mirror://sourceforge/h323plus/${MY_PN}-v${MY_PV}.tar.gz"

LICENSE="MPL-1.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/ptlib:=
	net-libs/h323plus:="
RDEPEND="${DEPEND}"

S=${WORKDIR}/applications/${PN}

src_prepare() {
	# set path for various files
	eapply "${FILESDIR}"/${PN}-2.2.1-path.patch

	default
}

src_compile() {
	emake OPENH323DIR=/usr/share/openh323
}

src_install() {
	dosbin obj_*_*_*/${PN}

	keepdir /usr/share/${PN}/data /usr/share/${PN}/html

	# needed for daemon
	keepdir /var/log/${PN} /var/run/${PN}

	insinto /usr/share/${PN}/sounds
	doins *.wav

	insinto /etc/${PN}
	doins server.pem
	doins "${FILESDIR}"/${PN}.ini

	doman ${PN}.1

	dodoc ReadMe.txt

	newinitd "${FILESDIR}"/${PN}.rc6 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

pkg_preinst() {
	enewgroup openmcu
	enewuser openmcu -1 -1 /dev/null openmcu
}

pkg_postinst() {
	einfo "Setting permissions..."
	chown -R openmcu:openmcu "${ROOT}"etc/openmcu
	chmod -R u=rwX,g=rX,o=   "${ROOT}"etc/openmcu
	chown -R openmcu:openmcu "${ROOT}"var/{log,run}/openmcu
	chmod -R u=rwX,g=rX,o=   "${ROOT}"var/{log,run}/openmcu

	echo
	elog "This patched version of openmcu stores it's configuration"
	elog "in \"/etc/openmcu/openmcu.ini\""
}
