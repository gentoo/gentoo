# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

## Build the tarball:
## ./build.sh --configuration Release --architecture x64 \
##     /p:ArcadeBuildTarball=true /p:TarballDir="$(pwd)/dotnet-sdk-7.0.105"
## cd dotnet-sdk-7.0.105
## ./prep.sh --bootstrap
## cd ..
## tar --create --auto-compress --file dotnet-sdk-7.0.105.tar.xz dotnet-sdk-7.0.105
## mv dotnet-sdk-7.0.105.tar.xz dotnet-sdk-7.0.1050-prepared-gentoo-amd64.tar.xz
## upload dotnet-sdk-7.0.1050-amd64.tar.xz

EAPI=8

LLVM_MAX_SLOT=16
PYTHON_COMPAT=( python3_{10..12} )

inherit check-reqs llvm python-any-r1

DESCRIPTION=".NET is a free, cross-platform, open-source developer platform"
HOMEPAGE="https://dotnet.microsoft.com/"
SRC_URI="
	amd64? ( https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}-prepared-gentoo-amd64.tar.xz )
"

SDK_SLOT="$(ver_cut 1-2)"
RUNTIME_SLOT="${SDK_SLOT}.5"
SLOT="${SDK_SLOT}/${RUNTIME_SLOT}"

LICENSE="MIT"
KEYWORDS="~amd64"

BDEPEND="
	${PYTHON_DEPS}
	<sys-devel/clang-$(( LLVM_MAX_SLOT + 1 ))
	dev-util/cmake
	dev-vcs/git
"
RDEPEND="
	app-crypt/mit-krb5:0/0
	dev-libs/icu
	dev-libs/openssl:=
	dev-util/lttng-ust:0/2.12
	sys-libs/zlib:0/1
"
IDEPEND="app-eselect/eselect-dotnet"
PDEPEND="
	~dev-dotnet/dotnet-runtime-nugets-${RUNTIME_SLOT}
	~dev-dotnet/dotnet-runtime-nugets-3.1.32
	~dev-dotnet/dotnet-runtime-nugets-6.0.16
"

CHECKREQS_DISK_BUILD="20G"

# QA_PREBUILT="*"  # TODO: Which binaries are created by dotnet itself?

pkg_setup() {
	check-reqs_pkg_setup
	llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	default

	unset DOTNET_ROOT
	unset NUGET_PACKAGES

	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export MSBUILDDISABLENODEREUSE=1
	export UseSharedCompilation=false
}

src_compile() {
	# Remove .NET leftover files that block build.
	if [[ -f /tmp/PackageVersions.props ]] ; then
		rm /tmp/PackageVersions.props           # nonfatal
	fi

	ebegin "Building .NET SDK ${SDK_SLOT}"
	bash ./build.sh --clean-while-building
	eend ${?} || die "build failed"
}

src_install() {
	local dest=/usr/$(get_libdir)/${PN}-${SDK_SLOT}
	dodir ${dest}

	ebegin "Extracting SDK archive"
	tar xzf artifacts/*/Release/${P}-*.tar.gz -C "${ED}"/${dest}
	eend ${?} || die "extraction failed"

	fperms 0755 ${dest}
	dosym -r ${dest}/dotnet /usr/bin/dotnet-${SDK_SLOT}
}

pkg_postinst() {
	eselect dotnet update ifunset
}

pkg_postrm() {
	eselect dotnet update ifunset
}
