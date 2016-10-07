# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Software for processing single-crystal X-ray monochromatic diffraction data"
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
	default
	mv XDS-* "${S}" || die
}

src_install() {
	local HTML_DOCS=( "${WORKDIR}"/XDS_html_doc/. )
	einstalldocs

	local i suffix=$(usex smp '_par' '')
	exeinto /opt/${PN}
	doexe *

	for i in xds mintegrate mcolspot xscale; do
		dosym ../${PN}/${i}${suffix} /opt/bin/${i}
	done

	for i in 2cbf cellparm forkcolspot forkintegrate merge2cbf pix2lab xdsconv; do
		dosym ../${PN}/${i} /opt/bin/${i}
	done

	insinto /usr/share/${PN}/INPUT_templates
	doins -r "${WORKDIR}"/XDS_html_doc/html_doc/INPUT_templates/.
}

pkg_postinst() {
	elog "This package will expire on April 30, 2017"
}
