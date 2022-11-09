# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=$(ver_cut 1-2)

DESCRIPTION="NVIDIA Ray Tracing Engine"
HOMEPAGE="https://developer.nvidia.com/optix"
SRC_URI="!headers-only? ( NVIDIA-OptiX-SDK-${PV}-linux64-x86_64.sh )"
S="${WORKDIR}"

HEADER_INTERNAL_FILES="
optix_7_device_impl.h
optix_7_device_impl_exception.h
optix_7_device_impl_transformations.h
"

HEADER_FILES="
optix.h
optix_7_device.h
optix_7_host.h
optix_7_types.h
optix_denoiser_tiling.h
optix_device.h
optix_function_table.h
optix_function_table_definition.h
optix_host.h
optix_stack_size.h
optix_stubs.h
optix_types.h
"

for i in ${HEADER_INTERNAL_FILES}; do
	SRC_URI+=" headers-only? ( https://developer.download.nvidia.com/redist/optix/v${MY_PV}/internal/${i} -> ${P}-internal-${i} )"
done
for i in ${HEADER_FILES}; do
	SRC_URI+=" headers-only? ( https://developer.download.nvidia.com/redist/optix/v${MY_PV}/${i} -> ${P}-${i} )"
done
unset i

LICENSE="NVIDIA-SDK"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="bindist mirror !headers-only? ( fetch )"
IUSE="+headers-only"

RDEPEND=">=x11-drivers/nvidia-drivers-510"

pkg_nofetch() {
	einfo "Please download ${A} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	local i
	if use headers-only; then
		mkdir -p "${S}/include/internal" || die
		for i in ${HEADER_INTERNAL_FILES}; do
			cp "${DISTDIR}/${P}-internal-${i}" "${S}/include/internal/${i}" || die
		done
		for i in ${HEADER_FILES}; do
			cp "${DISTDIR}/${P}-${i}" "${S}/include/${i}" || die
		done
	else
		tail -n +223 "${DISTDIR}"/${A} | tar -zx
		assert "unpacking ${A} failed"
	fi
}

src_install() {
	insinto /opt/${PN}
	doins -r include

	if use !headers-only; then
		DOCS=( doc/OptiX_{API_Reference,Programming_Guide}_${PV}.pdf )
		einstalldocs
	fi
}
