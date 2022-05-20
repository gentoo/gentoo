# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27 ruby30 ruby31"
inherit autotools flag-o-matic multilib-minimal ruby-single

DESCRIPTION="Alternative to vendor specific OpenCL ICD loaders"
HOMEPAGE="https://github.com/OCL-dev/ocl-icd"
SRC_URI="https://github.com/OCL-dev/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Does nothing now but by keeping it here we avoid having to have virtual/opencl
# handle ebuilds both with and without this flag.
IUSE="+khronos-headers"

BDEPEND="${RUBY_DEPS}"
DEPEND=">=dev-util/opencl-headers-2021.04.29"
RDEPEND="${DEPEND}
	!app-eselect/eselect-opencl
	!dev-libs/opencl-icd-loader"

src_prepare() {
	replace-flags -Os -O2 # bug 646122

	default
	eautoreconf
}

multilib_src_configure() {
	# dev-util/opencl-headers ARE official Khronos Group headers, what this option
	# does is disable the use of the bundled ones
	ECONF_SOURCE="${S}" econf --enable-pthread-once --disable-official-khronos-headers
}

multilib_src_compile() {
	local candidates=(${USE_RUBY})
	local ruby=
	for (( idx=${#candidates[@]}-1 ; idx>=0 ; idx-- )) ; do
		if ${candidates[idx]} --version &> /dev/null; then
			ruby=${candidates[idx]} && break
		fi
	done
	[[ -z ${ruby} ]] && die "No ruby executable found"

	emake RUBY=${ruby}
}

multilib_src_install() {
	default

	# Drop .la files
	find "${ED}" -name '*.la' -delete || die
}
