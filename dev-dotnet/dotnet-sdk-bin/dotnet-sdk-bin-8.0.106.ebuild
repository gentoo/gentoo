# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SDK_SLOT="$(ver_cut 1-2)"
RUNTIME_SLOT="${SDK_SLOT}.6"

DESCRIPTION=".NET is a free, cross-platform, open-source developer platform"
HOMEPAGE="https://dotnet.microsoft.com/
	https://github.com/dotnet/dotnet/"
SRC_URI="
amd64? (
	elibc_glibc? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-x64.tar.gz )
	elibc_musl? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-musl-x64.tar.gz )
)
arm? (
	elibc_glibc? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-arm.tar.gz )
	elibc_musl? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-musl-arm.tar.gz )
)
arm64? (
	elibc_glibc? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-arm64.tar.gz )
	elibc_musl? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-musl-arm64.tar.gz )
)
"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="${SDK_SLOT}/${RUNTIME_SLOT}"
# See bug https://bugs.gentoo.org/932377
KEYWORDS="amd64 ~arm ~arm64"

# STRIP="llvm-strip" corrupts some executables when using the patchelf hack,
# bug https://bugs.gentoo.org/923430
RESTRICT="splitdebug strip"

CURRENT_NUGETS_DEPEND="
	~dev-dotnet/dotnet-runtime-nugets-${RUNTIME_SLOT}
"
EXTRA_NUGETS_DEPEND="
	~dev-dotnet/dotnet-runtime-nugets-6.0.31
	~dev-dotnet/dotnet-runtime-nugets-7.0.20
"
NUGETS_DEPEND="
	${CURRENT_NUGETS_DEPEND}
	${EXTRA_NUGETS_DEPEND}
"

RDEPEND="
	app-crypt/mit-krb5:0/0
	dev-libs/icu
	dev-util/lttng-ust:0/2.12
	sys-libs/zlib:0/1
"
BDEPEND="
	dev-util/patchelf
"
IDEPEND="
	app-eselect/eselect-dotnet
"
PDEPEND="
	${NUGETS_DEPEND}
"

QA_PREBUILT="*"

MUSL_BAD_LINKS=(
	apphost
	createdump
	dotnet
	libSystem.Globalization.Native.so
	libSystem.IO.Compression.Native.so
	libSystem.Native.so
	libSystem.Net.Security.Native.so
	libSystem.Security.Cryptography.Native.OpenSsl.so
	libclrgc.so
	libclrjit.so
	libcoreclr.so
	libcoreclrtraceptprovider.so
	libdbgshim.so
	libhostfxr.so
	libhostpolicy.so
	libmscordaccore.so
	libmscordbi.so
	libnethost.so
	singlefilehost
)
MUSL_BAD_SONAMES=(
	libc.musl-aarch64.so.1
	libc.musl-armv7.so.1
	libc.musl-x86_64.so.1
)

src_prepare() {
	default

	# Fix musl libc SONAME links, bug https://bugs.gentoo.org/894760
	if use elibc_musl ; then
		local musl_bad_link
		local musl_bad_link_path
		local musl_bad_soname

		for musl_bad_link in "${MUSL_BAD_LINKS[@]}" ; do
			while read -r musl_bad_link_path ; do
				# Skip if file either does not end with ".so" or is not executable.
				# Using "case" here for easier matching in case we have to add
				# a special exception.
				case "${musl_bad_link_path}" in
					*.so )
						:
						;;
					* )
						if [[ ! -x "${musl_bad_link_path}" ]] ; then
							continue
						fi
						;;
				esac

				einfo "Fixing musl libc link for ${musl_bad_link_path}"

				for musl_bad_soname in "${MUSL_BAD_SONAMES[@]}" ; do
					patchelf --remove-needed "${musl_bad_soname}" "${musl_bad_link_path}" || die
				done

				patchelf --add-needed libc.so "${musl_bad_link_path}" || die
			done < <(find . -type f -name "${musl_bad_link}")
		done
	fi

	# Remove static libraries, bug https://bugs.gentoo.org/825774
	find ./packs -type f -name "libnethost.a" -delete || die
}

src_install() {
	local dest="opt/${PN}-${SDK_SLOT}"
	dodir "${dest%/*}"

	# Create a magic workloads file, bug #841896
	local featureband="$(( $(ver_cut 3) / 100 * 100 ))"       # e.g. 404 -> 400
	local workloads="metadata/workloads/${SDK_SLOT}.${featureband}"

	mkdir -p "${S}/${workloads}" || die
	touch "${S}/${workloads}/userlocal" || die

	mv "${S}" "${ED}/${dest}" || die
	mkdir "${S}" || die

	fperms 0755 "/${dest}"
	dosym "../../${dest}/dotnet" "/usr/bin/dotnet-bin-${SDK_SLOT}"
}

pkg_postinst() {
	eselect dotnet update ifunset
}

pkg_postrm() {
	eselect dotnet update ifunset
}
