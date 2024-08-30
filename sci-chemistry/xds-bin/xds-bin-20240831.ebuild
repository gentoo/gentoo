# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Software for processing single-crystal X-ray monochromatic diffraction data"
HOMEPAGE="https://xds.mr.mpg.de"
SRC_URI="
	https://xds.mr.mpg.de/XDS-INTEL64_Linux_x86_64.tar.gz -> XDS-INTEL64_Linux_x86_64-${PVR}.tar.gz
	https://xds.mr.mpg.de/XDS_html_doc.tar.gz -> XDS_html_doc-${PVR}.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="smp"
RESTRICT="fetch"

QA_PREBUILT="opt/xds-bin/*"

# The web site uses a certificate that is not in the system certificate store.
# Use a web browser to download, instead.
pkg_nofetch() {
	elog "Please visit"
	elog "https://xds.mr.mpg.de/html_doc/downloading.html"
	elog "and download XDS-INTEL64_Linux_x86_64.tar.gz and XDS_html_doc.tar.gz."
	elog "Please save them as: ${A}. in your \${DISTDIR}"
}

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

	for i in 2cbf cellparm forkxds merge2cbf pix2lab xdsconv; do
		dosym ../${PN}/${i} /opt/bin/${i}
	done

	insinto /usr/share/${PN}/INPUT_templates
	doins -r "${WORKDIR}"/XDS_html_doc/html_doc/INPUT_templates/.
}

pkg_postinst() {
	elog "This package will expire on August 31, 2024"
}
