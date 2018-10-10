# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby23 ruby24 ruby25"
inherit autotools flag-o-matic multilib-minimal ruby-single

DESCRIPTION="Alternative to vendor specific OpenCL ICD loaders"
HOMEPAGE="https://github.com/OCL-dev/ocl-icd"
SRC_URI="https://github.com/OCL-dev/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+khronos-headers"

DEPEND="${RUBY_DEPS}"
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
	default

	# Drop .la files
	find "${D}" -name '*.la' -delete || die

	OCL_DIR="/usr/$(get_libdir)/OpenCL/vendors/ocl-icd"
	dodir ${OCL_DIR}/{,include}

	# Install vendor library
	mv -f "${D}/usr/$(get_libdir)"/libOpenCL* "${ED}${OCL_DIR}" || die "Can't install vendor library"

	# Install vendor headers
	if use khronos-headers; then
		cp -r "${S}/khronos-headers/CL" "${ED}${OCL_DIR}/include" || die "Can't install vendor headers"
	fi
}

pkg_postinst() {
	eselect opencl set --use-old ${PN}
}
