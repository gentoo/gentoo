# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs

# Disclaimer: While a bunch of generated .il (.net assembly) files can be
#  considered not to be *source code* per se, none of the files here contain
#  any actual code. Only symbols/references for a variety of libs.

DESCRIPTION=".NET Source-build Reference Packages"
HOMEPAGE="https://github.com/dotnet/source-build-reference-packages/"

BOOT_PV="5.0.202"
BOOT_ARTIFACTS_PV="0.1.0-${BOOT_PV}-1088763-20210414.1"  # See eng/Versions.props
BOOT_ARTIFACTS_P="Private.SourceBuilt.Artifacts.${BOOT_ARTIFACTS_PV}"
BOOT_SRC_URI="https://dotnetcli.azureedge.net/dotnet/Sdk/${BOOT_PV}/dotnet-sdk-${BOOT_PV}-linux-x64.tar.gz
	https://dotnetcli.azureedge.net/source-built-artifacts/assets/${BOOT_ARTIFACTS_P}.tar.gz -> dotnet-${BOOT_ARTIFACTS_P}.tar.gz
"

MY_PN="source-build-reference-packages"
MY_PV="6ce5818b1c1828ccdc8ac63d460d029c6391a401"  # Branch: pre-arcade
SRC_URI="https://github.com/dotnet/source-build-reference-packages/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	!system-bootstrap? ( ${BOOT_SRC_URI} )
"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

LICENSE="MIT"
SLOT="5.0"
KEYWORDS="~amd64"
IUSE="system-bootstrap"

BDEPEND="
	system-bootstrap? (
		|| (
			>=dev-dotnet/dotnet-sdk-${BOOT_PV}
			>=dev-dotnet/dotnet-sdk-bin-${BOOT_PV}
		)
	)
"

PATCHES=(
	"${FILESDIR}"/dotnet-reference-packages-fix-bashisms.patch
)

CHECKREQS_DISK_BUILD="14G"
CHECKREQS_DISK_USR="400M"

dotnet_unpack() {
	if ! use system-bootstrap; then
		mkdir "${WORKDIR}"/dotnet || die
		cd "${WORKDIR}"/dotnet || die
		unpack "dotnet-sdk-${BOOT_PV}-linux-x64.tar.gz"

		mkdir source-artifacts || die
		cd source-artifacts || die
		unpack "dotnet-${BOOT_ARTIFACTS_P}.tar.gz"
	fi
}

dotnet_find() {
	if ! use system-bootstrap; then
		DOTNET_ROOT="${WORKDIR}"/dotnet
		return
	fi

	for x in "${DOTNET_ROOT}" "${BROOT}"/usr/lib/dotnet-sdk-${SLOT} "${BROOT}"/opt/dotnet-sdk-bin-${SLOT}; do
		if [[ -d "${x}" ]] && [[ -d "${x}"/source-artifacts ]]; then
			DOTNET_ROOT="${x}"
			break
		fi
	done

	if [[ ! -d "${DOTNET_ROOT}" ]]; then
		die "Can't find installed .NET SDK (including Source-built Artifacts)"
	fi
}

src_unpack() {
	unpack "${P}.tar.gz"
	dotnet_unpack
}

src_prepare() {
	sed -i -e '/setupSourceBuiltArtifacts.proj/c:' build.sh || die
	default
}

src_configure() {
	dotnet_find

	# --with-packages only likes being pointed at a tarball, so we symlink it
	#  manually instead.
	mkdir artifacts || die
	ln -s "${DOTNET_ROOT}"/source-artifacts artifacts/source-built || die
}

src_compile() {
	dotnet_find

	# Avoid dependency on dev-libs/icu
	# (required by source-build sdk anyway, but doesn't hurt)
	export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

	./build.sh --with-sdk "${DOTNET_ROOT}" || die
}

src_install() {
	insinto "/usr/lib/dotnet-sdk-${SLOT}"
	doins -r artifacts/reference-packages
}
