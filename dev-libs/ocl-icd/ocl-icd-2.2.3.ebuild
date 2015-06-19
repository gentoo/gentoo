# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/ocl-icd/ocl-icd-2.2.3.ebuild,v 1.2 2015/03/31 18:15:32 ulm Exp $

EAPI=5

inherit multilib

DESCRIPTION="Alternative to vendor specific OpenCL ICD loaders"
HOMEPAGE="http://forge.imag.fr/projects/ocl-icd/"
SRC_URI="https://forge.imag.fr/frs/download.php/598/${P}.tar.gz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="dev-lang/ruby"
RDEPEND="app-eselect/eselect-opencl"

src_prepare() {
	echo "/usr/$(get_libdir)/OpenCL/vendors/ocl-icd/libOpenCL.so" > ocl-icd.icd
}

src_install() {
	insinto /etc/OpenCL/vendors/
	doins ocl-icd.icd

	emake DESTDIR="${D}" install

	OCL_DIR="${D}"/usr/"$(get_libdir)"/OpenCL/vendors/ocl-icd/
	mkdir -p ${OCL_DIR} || die "mkdir failed"

	mv "${D}/usr/$(get_libdir)"/libOpenCL* "${OCL_DIR}"
}
