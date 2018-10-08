# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="Alternative to vendor specific OpenCL ICD loaders"
HOMEPAGE="https://github.com/OCL-dev/ocl-icd"
SRC_URI="https://github.com/OCL-dev/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="dev-lang/ruby
	dev-ruby/rubygems"
RDEPEND="app-eselect/eselect-opencl"

src_prepare() {
	replace-flags -Os -O2 # bug 646122

	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf --enable-pthread-once
}

multilib_src_install() {
	find "${D}" -name '*.la' -delete || die

	echo "/usr/$(get_libdir)/OpenCL/vendors/ocl-icd/libOpenCL.so" > "${PN}-${ABI}.icd"
	insinto /etc/OpenCL/vendors/
	doins "${PN}-${ABI}.icd"

	emake DESTDIR="${D}" install

	OCL_DIR="${D}"/usr/"$(get_libdir)"/OpenCL/vendors/ocl-icd/
	mkdir -p ${OCL_DIR} || die "mkdir failed"

	mv "${D}/usr/$(get_libdir)"/libOpenCL* "${OCL_DIR}"
}
