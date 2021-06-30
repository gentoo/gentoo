# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs toolchain-funcs flag-o-matic multiprocessing

DESCRIPTION=".NET SDK (includes .NET Runtime + ASP.NET)"
HOMEPAGE="https://dotnet.microsoft.com/"

BOOT_PV="5.0.202"
BOOT_ARTIFACTS_PV="0.1.0-${BOOT_PV}-1088763-20210414.1"  # See eng/Versions.props
BOOT_ARTIFACTS_P="Private.SourceBuilt.Artifacts.${BOOT_ARTIFACTS_PV}"
BOOT_SRC_URI="https://dotnetcli.azureedge.net/dotnet/Sdk/${BOOT_PV}/dotnet-sdk-${BOOT_PV}-linux-x64.tar.gz
	https://dotnetcli.azureedge.net/source-built-artifacts/assets/${BOOT_ARTIFACTS_P}.tar.gz -> dotnet-${BOOT_ARTIFACTS_P}.tar.gz
"

# Upstream doesn't provide proper release tarballs, so source tarballs must be
#  generated downstream. Due to the complicated build system and reliance on
#  the closed-source "Darc CLI" tool (which requires an older SDK version),
#  it's not trivial to gather sources from within the ebuild.
# Thankfully, upstream does provide a build-source-tarball.sh script that may
#  be used to generate a tarball. It's a tad bulky to run, however.

# Fedora kindly hosts pre-packaged sources at:
# https://src.fedoraproject.org/lookaside/pkgs/dotnet5.0/
# Fedora's packaging script can be found at:
# https://src.fedoraproject.org/rpms/dotnet5.0/blob/rawhide/f/build-dotnet-tarball
# Unfortunately, Fedora might be a bit slow with updates at times.

# Alternative source packaging script:
# https://gist.github.com/mid-kid/e1b472bafa6bf74d235ec3a9d2b6bcc0

#SHA512=""
#SRC_URI="https://src.fedoraproject.org/lookaside/pkgs/dotnet5.0/${MY_P}.tar.gz/sha512/${SHA512}/${MY_P}.tar.gz"

MY_P="dotnet-v${PV}-SDK"
SRC_URI="https://archive.org/download/dotnet-v5.0.207-SDK.tar/${MY_P}.tar.xz
	https://src.fedoraproject.org/rpms/dotnet5.0/raw/7f6b8ec3f9527a6fbc89018ce31cdcfecc474edd/f/sdk-telemetry-optout.patch -> dotnet-sdk-telemetry-optout.patch
	!system-bootstrap? ( ${BOOT_SRC_URI} )
"
S="${WORKDIR}/${MY_P}"

# https://github.com/dotnet/runtime/blob/release/5.0/src/installer/pkg/packaging/deb/dotnet-runtime-deps-debian_config.json#L27
LICENSE="MIT Apache-2.0 BSD"
SLOT="5.0"
KEYWORDS="~amd64"
IUSE="llvm-libunwind +system-libunwind system-bootstrap +dotnet-symlink"

RDEPEND="
	app-crypt/mit-krb5
	dev-libs/icu
	dev-util/lttng-ust
	system-libunwind? (
		llvm-libunwind? ( sys-libs/llvm-libunwind )
		!llvm-libunwind? ( sys-libs/libunwind )
	)
	dotnet-symlink? ( !dev-dotnet/dotnet-sdk-bin[dotnet-symlink(+)] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/cmake
	dev-vcs/git
	dev-dotnet/dotnet-reference-packages:${SLOT}
	system-bootstrap? (
		|| (
			>=dev-dotnet/dotnet-sdk-${BOOT_PV}
			>=dev-dotnet/dotnet-sdk-bin-${BOOT_PV}
		)
	)
"

CHECKREQS_DISK_BUILD="24G"
CHECKREQS_DISK_USR="1200M"

# Use ninja unless emake is explicitly requested
# Adapted from cmake.eclass
case ${CMAKE_MAKEFILE_GENERATOR:-ninja} in
	emake)
		BDEPEND+=" sys-devel/make"
		CMAKE_GENERATOR_FLAG=""
		;;
	ninja|*)
		BDEPEND+=" dev-util/ninja"
		CMAKE_GENERATOR_FLAG="-ninja"
		;;
esac

# If the package can't be built using gcc currently, set this to "true"
DOTNET_FORCE_CLANG="true"

if ${DOTNET_FORCE_CLANG}; then
	BDEPEND+=" sys-devel/clang"
fi

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

dotnet_find_reference() {
	# Handle the case where we're bootstrapping with a binary sdk,
	#  but the reference-packages have just been installed in /usr/lib
	for x in "${DOTNET_ROOT}"/reference-packages "${BROOT}"/usr/lib/dotnet-sdk-${SLOT}/reference-packages; do
		if [[ -d "${x}" ]]; then
			DOTNET_REFERENCE="${x}"
			break
		fi
	done

	if [[ ! -d "${DOTNET_REFERENCE}" ]]; then
		die "Can't find installed .NET Source-build Reference Packages"
	fi
}

dotnet_get_arch() {
	local arch=""
	use x86 && arch="x86"
	use amd64 && arch="x64"
	use arm && arch="arm"
	use arm64 && arch="arm64"
	[[ -z "$arch" ]] && die "Architecture not supported by .NET Core"
	echo "$arch"
}

src_unpack() {
	unpack "${MY_P}.tar.xz"
	dotnet_unpack
}

src_prepare() {
	# add_patch <submodule> <file.patch>
	add_patch() {
		cp "${2}" "patches/${1}/9000-$(basename "${2}")" || die
	}

	eapply "${FILESDIR}"/dotnet-sdk-5.0.203-additional-arguments.patch
	add_patch sdk "${DISTDIR}"/dotnet-sdk-telemetry-optout.patch
	add_patch runtime "${FILESDIR}"/dotnet-sdk-5.0.203-runtime-add-gentoo-ids.patch
	add_patch runtime "${FILESDIR}"/dotnet-sdk-5.0.203-runtime-additional-arguments.patch
	add_patch runtime "${FILESDIR}"/dotnet-sdk-5.0.203-runtime-as-needed.patch
	add_patch runtime "${FILESDIR}"/dotnet-sdk-5.0.203-runtime-locate-ranlib.patch
	add_patch runtime "${FILESDIR}"/dotnet-sdk-5.0.203-runtime-detect-lld.patch

	# Rename the artifacts directory depending on the current arch
	mv -vT artifacts/obj/*/ artifacts/obj/$(dotnet_get_arch)/

	default
}

src_configure() {
	dotnet_find

	# SDK is modified in-place...
	if use system-bootstrap; then
		mkdir -p dotnet || die
		ln -s "${DOTNET_ROOT}"/{host,packs,shared} dotnet || die
		cp -a "${DOTNET_ROOT}"/{dotnet,sdk} dotnet || die
	else
		ln -s "${DOTNET_ROOT}" dotnet || die
	fi
}

src_compile() {
	dotnet_find
	dotnet_find_reference

	# Required for --with-packages to work
	rm -rf packages/archive

	local mybuildargs=(
		--with-sdk dotnet
		--with-packages "${DOTNET_ROOT}"/source-artifacts
		--with-ref-packages "${DOTNET_REFERENCE}"
		--

		/p:UseSystemLibraries=true
		/p:UseSystemLibunwind=$(usex system-libunwind true false)

		/p:LogVerbosity=normal
		/p:MinimalConsoleLogOutput=false
		/verbosity:normal

		# Not sure if this has any effect on the subprocesses
		/maxCpuCount:$(makeopts_jobs)

		# /p:AdditionalBuildArguments are passed to src/runtime.*/eng/build.sh
		# /p:NativeBuildArguments are passed to src/runtime.*/eng/native/build-commons.sh
		/p:AdditionalBuildArguments="-cmakeargs -DCMAKE_VERBOSE_MAKEFILE=ON"
		/p:NativeBuildArguments="${CMAKE_GENERATOR_FLAG} -numproc $(makeopts_jobs)"
		# If any dotnet maintainer is reading this: Please honor the
		#  CMAKE_MAKEFILE_GENERATOR and MAKEFLAGS variables if set.
	)

	# Adapted from www-client/firefox
	if ${DOTNET_FORCE_CLANG} && ! tc-is-clang; then
		einfo "Enforcing the use of Clang due to build errors..."
		AR=llvm-ar
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		NM=llvm-nm
		OBJCOPY=llvm-objcopy
		OBJDUMP=llvm-objdump
		RANLIB=llvm-ranlib

		# If a user is using clang already, and has `-flto` in their flags,
		#  we assume that this user is already using LLD.
		# This check is purely for GCC users with -flto=n in their flags.
		if is-flagq '-flto*' && ! has_version 'sys-devel/clang[default-lld]'; then
			has_version sys-devel/lld || die "Please install sys-devel/lld (or sys-devel/clang[default-lld]) to build with LTO"
			einfo "Enforcing the use of LLD for Clang LTO..."
			append-ldflags '-fuse-ld=lld'

			# GCC's -flto=n option isn't compatible with Clang.
			append-flags '-flto'
		fi

		strip-unsupported-flags
	fi

	# Building with libcxx currently fails
	if tc-is-clang && ( is-flagq '-stdlib=libc++' || has_version 'sys-devel/clang[default-libcxx]' ); then
		append-cxxflags '-stdlib=libstdc++'
		append-ldflags '-stdlib=libstdc++'
	fi

	# For the CLR_* variables, the full path is necessary, see:
	# - src/runtime.*/eng/native/init-compiler.sh
	# - src/runtime.*/eng/native/configuretools.cmake
	# NM, OBJCOPY and OBJDUMP don't seem to be used currently (ver 5.0.203).
	for var in AR CC CXX NM OBJCOPY OBJDUMP RANLIB; do
		local prog="$(tc-get${var})"
		local path="$(type -p "${prog}")"
		[[ -n "${path}" ]] || die "Can't find ${prog} (\${${var}}) in \${PATH}!"
		export CLR_${var}="${path}"
	done

	# EXTRA_* currently (ver 5.0.203) don't seem to be required, but might be
	#  in the future. Specifying flags twice never hurt anyone, anyway.
	# See src/runtime.*/eng/native/build-commons.sh
	export EXTRA_CFLAGS="${CFLAGS}"
	export EXTRA_CXXFLAGS="${CXXFLAGS}"
	export EXTRA_LDFLAGS="${LDFLAGS}"

	./build.sh "${mybuildargs[@]}" || die
}

src_install() {
	local dest="/usr/lib/${PN}-${SLOT}"
	local ddest="${ED}/${dest#/}"

	dodir "${dest}"
	tar xf artifacts/*/Release/dotnet-sdk-*.tar.gz -C "${ddest}" || die

	dodir "${dest}"/source-artifacts
	tar xf artifacts/*/Release/Private.SourceBuilt.Artifacts.*.tar.gz -C "${ddest}"/source-artifacts || die

	# EAPI8: use dosym -r
	dosym "../../${dest#/}/dotnet" /usr/bin/dotnet-${SLOT}

	if use dotnet-symlink; then
		dosym "../../${dest#/}/dotnet" /usr/bin/dotnet

		echo "DOTNET_ROOT=\"${EPREFIX}${dest}\"" > "${T}/90${PN}-${SLOT}"
		doenvd "${T}/90${PN}-${SLOT}"
	fi
}
