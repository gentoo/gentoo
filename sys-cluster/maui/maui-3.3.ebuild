# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/maui/maui-3.3.ebuild,v 1.3 2014/05/21 12:18:31 jlec Exp $

EAPI="3"

inherit autotools eutils multilib

DESCRIPTION="Maui Cluster Scheduler"
HOMEPAGE="http://www.adaptivecomputing.com/products/open-source/maui/"
SRC_URI="http://www.clusterresources.com/downloads/maui/${P/_/}.tar.gz"

IUSE=""
SLOT="0"
LICENSE="maui"
KEYWORDS="~amd64 ~x86 ~amd64-linux"

DEPEND="sys-cluster/torque"
RDEPEND="${DEPEND}"

RESTRICT="fetch mirror"

S="${WORKDIR}/${P/_/}"

src_prepare() {
	epatch "${FILESDIR}"/3.2.6_p21-autoconf-2.60-compat.patch
	# http://www.supercluster.org/pipermail/mauiusers/2010-March/004174.html
	epatch "${FILESDIR}"/maui-3.2.6_p21-pbs-nodefile.patch
	sed -i \
		-e "s~BUILDROOT=~BUILDROOT=${D}~" \
		"${S}"/Makefile.in
	eautoreconf
}

src_configure() {
	econf \
		--with-spooldir="${EPREFIX}"/usr/spool/maui \
		--with-pbs="${EPREFIX}"/usr/
}

src_install() {
	emake install INST_DIR="${ED}/usr"
	dodoc docs/README CHANGELOG || die
	dohtml docs/mauidocs.html || die
}

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE}, obtain the file"
	einfo "${P/_/}.tar.gz and put it in ${DISTDIR}"
}
