# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib

DESCRIPTION="Alternative to vendor specific OpenCL ICD loaders"
HOMEPAGE="http://forge.imag.fr/projects/ocl-icd/"
SRC_URI="https://forge.imag.fr/frs/download.php/598/${P}.tar.gz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="dev-lang/ruby
        dev-ruby/rubygems"
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
