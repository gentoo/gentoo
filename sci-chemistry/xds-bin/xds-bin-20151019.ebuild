# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="X-ray Detector Software for processing single-crystal monochromatic diffraction data"
HOMEPAGE="http://xds.mpimf-heidelberg.mpg.de/"
SRC_URI="
	ftp://ftp.mpimf-heidelberg.mpg.de/pub/kabsch/XDS-INTEL64_Linux_x86_64.tar.gz -> XDS-INTEL64_Linux_x86_64-${PV}.tar.gz
	ftp://ftp.mpimf-heidelberg.mpg.de/pub/kabsch/XDS_html_doc.tar.gz -> XDS_html_doc-${PV}.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="smp X"

RDEPEND="X? ( sci-visualization/xds-viewer )"
DEPEND=""

QA_PREBUILT="opt/xds-bin/*"

src_unpack() {
	unpack ${A}
	mv XDS-* "${S}"
}

src_install() {
	local suffix bin
	exeinto /opt/${PN}
	doexe *

	use smp && suffix="_par"

	for bin in xds mintegrate mcolspot xscale; do
		dosym ../${PN}/${bin}${suffix} /opt/bin/${bin}
	done

	for bin in 2cbf cellparm forkcolspot forkintegrate merge2cbf pixlab xdsconv; do
		dosym ../${PN}/${bin} /opt/bin/${bin}
	done

	dohtml -r "${WORKDIR}"/XDS_html_doc/*
	insinto /usr/share/${PN}/INPUT_templates
	doins "${WORKDIR}"/XDS_html_doc/html_doc/INPUT_templates/*
}

pkg_postinst() {
	elog "This package will expire on March 31, 2016"
}
