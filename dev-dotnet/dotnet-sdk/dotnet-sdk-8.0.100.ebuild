# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Build the tarball:
#   - "$" - shell command,
#   - ">" - manual action.
# $  git clone --depth 1 -b v8.0.0 https://github.com/dotnet/dotnet  \
#		 dotnet-sdk-8.0.0
# $  cd dotnet-sdk-8.0.0
# >  Note the checkout tag hash.
# $  ./prep.sh
# $  rm -fr .git
# $  cd ..
# $  tar --create --auto-compress --file  \
#        dotnet-sdk-8.0.100-prepared-gentoo-amd64.tar.xz dotnet-sdk-8.0.0
# >  Upload dotnet-sdk-8.0.0_rc1234194-prepared-gentoo-amd64.tar.xz

EAPI=8

COMMIT=113d797bc90104bb4f1cc51e1a462cf3d4ef18fc

LLVM_MAX_SLOT=16
PYTHON_COMPAT=( python3_{10..12} )

inherit check-reqs flag-o-matic llvm python-any-r1

DESCRIPTION=".NET is a free, cross-platform, open-source developer platform"
HOMEPAGE="https://dotnet.microsoft.com/
	https://github.com/dotnet/dotnet/"
SRC_URI="
	amd64? ( https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}-prepared-gentoo-amd64.tar.xz )
"

SDK_SLOT="$(ver_cut 1-2)"
RUNTIME_SLOT="${SDK_SLOT}.0"
SLOT="${SDK_SLOT}/${RUNTIME_SLOT}"

# SDK reports it is version "8.0.100" but the tag .NET SDK team had given
# it is "8.0.100". I feel that the pattern is to tag based on "RUNTIME_SLOT".
S="${WORKDIR}/${PN}-${RUNTIME_SLOT}"

LICENSE="MIT"
KEYWORDS="~amd64"

CURRENT_NUGETS_DEPEND="
	~dev-dotnet/dotnet-runtime-nugets-${RUNTIME_SLOT}
"
EXTRA_NUGETS_DEPEND="
	~dev-dotnet/dotnet-runtime-nugets-3.1.32
	~dev-dotnet/dotnet-runtime-nugets-6.0.25
	~dev-dotnet/dotnet-runtime-nugets-7.0.14
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
	dev-util/cmake
	dev-vcs/git
"
IDEPEND="
	app-eselect/eselect-dotnet
"
PDEPEND="
	${NUGETS_DEPEND}
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

	ebegin "Building the .NET SDK ${SDK_SLOT}"
	bash ./build.sh									\
		--clean-while-building						\
		--source-repository "${source_repository}"	\
		--source-version "${COMMIT}"
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
