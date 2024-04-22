# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Pre-build (and distribution preparation)
# Build the tarball:
#  git clone --depth 1 -b v8.0.2 https://github.com/dotnet/dotnet dotnet-sdk-8.0.2
#  cd dotnet-sdk-8.0.2
#  git rev-parse HEAD
#  ./prep.sh
#  rm -fr .git
#  cd ..
#  tar -acf dotnet-sdk-8.0.201-prepared-gentoo-amd64.tar.xz dotnet-sdk-8.0.2
# Upload dotnet-sdk-8.0.201-prepared-gentoo-amd64.tar.xz

# Build ("src_compile")
# To learn about arguments that are passed to the "build.sh" script see:
# https://github.com/dotnet/source-build/discussions/4082
# User variable: GENTOO_DOTNET_BUILD_VERBOSITY - set other verbosity log level.

EAPI=8

COMMIT=d396b0c4d3e51c2d8d679b2f7233912bc5bfc2fa
SDK_SLOT="$(ver_cut 1-2)"
RUNTIME_SLOT="${SDK_SLOT}.2"

LLVM_MAX_SLOT=17
PYTHON_COMPAT=( python3_{10..12} )

inherit check-reqs flag-o-matic llvm multiprocessing python-any-r1

DESCRIPTION=".NET is a free, cross-platform, open-source developer platform"
HOMEPAGE="https://dotnet.microsoft.com/
	https://github.com/dotnet/dotnet/"
SRC_URI="
amd64? (
	elibc_glibc? ( https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}-prepared-gentoo-amd64.tar.xz )
	elibc_musl? ( https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}-prepared-gentoo-musl-amd64.tar.xz )
)
"
S="${WORKDIR}/${PN}-${RUNTIME_SLOT}"

LICENSE="MIT"
SLOT="${SDK_SLOT}/${RUNTIME_SLOT}"
KEYWORDS="amd64"

# STRIP="llvm-strip" corrupts some executables when using the patchelf hack.
# Be safe and restrict it for source-built too, bug https://bugs.gentoo.org/923430
RESTRICT="splitdebug strip"

CURRENT_NUGETS_DEPEND="
	~dev-dotnet/dotnet-runtime-nugets-${RUNTIME_SLOT}
"
EXTRA_NUGETS_DEPEND="
	~dev-dotnet/dotnet-runtime-nugets-6.0.27
	~dev-dotnet/dotnet-runtime-nugets-7.0.16
"
NUGETS_DEPEND="
	${CURRENT_NUGETS_DEPEND}
	${EXTRA_NUGETS_DEPEND}
"
RDEPEND="
	app-crypt/mit-krb5:0/0
	dev-libs/icu
	dev-libs/openssl:=
	dev-util/lttng-ust:0/2.12
	sys-libs/zlib:0/1
"
BDEPEND="
	${PYTHON_DEPS}
	<sys-devel/clang-$(( LLVM_MAX_SLOT + 1 ))
	dev-build/cmake
	dev-vcs/git
"
IDEPEND="
	app-eselect/eselect-dotnet
"
PDEPEND="
	${NUGETS_DEPEND}
"

CHECKREQS_DISK_BUILD="20G"
PATCHES=(
	"${FILESDIR}/${PN}-8.0.101-runtime-64.patch"
)

# Created by dotnet itself:
QA_PREBUILT="
usr/lib.*/dotnet-sdk-.*/dotnet
"
# .NET runtime, better to not touch it if they want some specific flags.
QA_FLAGS_IGNORED="
.*/apphost
.*/createdump
.*/libSystem.Globalization.Native.so
.*/libSystem.IO.Compression.Native.so
.*/libSystem.Native.so
.*/libSystem.Net.Security.Native.so
.*/libSystem.Security.Cryptography.Native.OpenSsl.so
.*/libclrgc.so
.*/libclrjit.so
.*/libcoreclr.so
.*/libcoreclrtraceptprovider.so
.*/libhostfxr.so
.*/libhostpolicy.so
.*/libmscordaccore.so
.*/libmscordbi.so
.*/libnethost.so
.*/singlefilehost
"

pkg_setup() {
	check-reqs_pkg_setup
	llvm_pkg_setup
	python-any-r1_pkg_setup

	if [[ "${MERGE_TYPE}" != binary ]] ; then
		if use elibc_glibc ; then
			local locales
			locales="$(locale -a)"

			if has en_US.utf8 ${locales} ; then
				LC_ALL=en_US.utf8
			elif has en_US.UTF-8 ${locales} ; then
				LC_ALL=en_US.UTF-8
			else
				eerror "The locale en_US.utf8 or en_US.UTF-8 is not available."
				eerror "Please generate en_US.UTF-8 before building ${CATEGORY}/${P}."

				die "Could not switch to the en_US.UTF-8 locale."
			fi
		else
			LC_ALL=en_US.UTF-8
		fi

		export LC_ALL
		einfo "Successfully switched to the ${LC_ALL} locale."
	fi
}

src_prepare() {
	default

	filter-lto

	unset DOTNET_ROOT
	unset NUGET_PACKAGES

	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
	export MSBUILDDISABLENODEREUSE=1
	export UseSharedCompilation=false

	local dotnet_sdk_tmp_directory="${WORKDIR}/dotnet-sdk-tmp"
	mkdir -p "${dotnet_sdk_tmp_directory}" || die

	# This should fix the "PackageVersions.props" problem,
	# see below, in src_compile.
	sed -e "s|/tmp|${dotnet_sdk_tmp_directory}|g" -i build.sh || die
}

src_compile() {
	# Remove .NET leftover files that can be blocking the build.
	# Keep this nonfatal!
	local package_versions_path="/tmp/PackageVersions.props"
	if [[ -f "${package_versions_path}" ]] ; then
		rm "${package_versions_path}" ||
			ewarn "Failed to remove ${package_versions_path}, build may fail!"
	fi

	# The "source_repository" should always be the same.
	local source_repository="https://github.com/dotnet/dotnet"
	local verbosity="${GENTOO_DOTNET_BUILD_VERBOSITY:-minimal}"

	ebegin "Building the .NET SDK ${SDK_SLOT}"
	local -a buildopts=(
		--clean-while-building
		--source-repository "${source_repository}"
		--source-version "${COMMIT}"

		--
		-maxCpuCount:"$(makeopts_jobs)"
		-verbosity:"${verbosity}"
		-p:ContinueOnPrebuiltBaselineError=true
		-p:LogVerbosity="${verbosity}"
		-p:MinimalConsoleLogOutput=false
		-p:verbosity="${verbosity}"
	)
	bash ./build.sh	"${buildopts[@]}"
	eend ${?} || die "build failed"
}

src_install() {
	local dest="/usr/$(get_libdir)/${PN}-${SDK_SLOT}"
	dodir "${dest}"

	ebegin "Extracting the .NET SDK archive"
	tar xzf artifacts/*/Release/${PN}-${SDK_SLOT}.*.tar.gz -C "${ED}/${dest}"
	eend ${?} || die "extraction failed"

	fperms 0755 "${dest}"
	dosym -r "${dest}/dotnet" "/usr/bin/dotnet-${SDK_SLOT}"
}

pkg_postinst() {
	eselect dotnet update ifunset
}

pkg_postrm() {
	eselect dotnet update ifunset
}
