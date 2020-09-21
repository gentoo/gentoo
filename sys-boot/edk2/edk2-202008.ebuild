# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )
PYTHON_REQ_USE="sqlite"

inherit multiprocessing python-single-r1 toolchain-funcs

DESCRIPTION="Tianocore UEFI Development kit"
HOMEPAGE="https://github.com/tianocore/tianocore.github.io/wiki/EDK-II"

BROTLI_VERSION=1.0.7
CMOCKA_VERSION=1.1.5
ONIGURUMA_VERSION=6.9.5
OPENSSL_VERSION=3.0.0-alpha5
SOFTFLOAT_VERSION=b64af41c3276f97f0e181920400ee056b9c88037

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tianocore/edk2.git"
	KEYWORDS=""
else
	FULL_V="stable${PV}"
	SRC_URI="https://github.com/tianocore/${PN}/archive/${PN}-${FULL_V}.tar.gz
		https://github.com/google/brotli/archive/v${BROTLI_VERSION}.tar.gz -> brotli-${BROTLI_VERSION}.tar.gz"
	S="${WORKDIR}/${PN}-${PN}-${FULL_V}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-2-Clause-Patent"
SLOT="0"
IUSE="brotli cmocka oniguruma openssl softfloat"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="strip"

SRC_URI+="
brotli? ( https://github.com/google/brotli/archive/v${BROTLI_VERSION}.tar.gz -> brotli-${BROTLI_VERSION}.tar.gz )
cmocka? ( https://git.cryptomilk.org/projects/cmocka.git/snapshot/cmocka-${CMOCKA_VERSION}.tar.gz )
oniguruma? ( https://github.com/kkos/oniguruma/archive/v${ONIGURUMA_VERSION}.tar.gz -> oniguruma-${ONIGURUMA_VERSION}.tar.gz )
openssl? ( https://github.com/openssl/openssl/archive/openssl-${OPENSSL_VERSION}.tar.gz )
softfloat? ( https://github.com/ucb-bar/berkeley-softfloat-3/archive/${SOFTFLOAT_VERSION}.tar.gz -> softfloat-${SOFTFLOAT_VERSION}.tar.gz )
"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	>=dev-lang/nasm-2.14.02
	>=sys-power/iasl-20160729"

# EFI pre-build libs
QA_PREBUILT="
	usr/lib/${P}/BeagleBoardPkg/Debugger_scripts/rvi_dummy.axf
	usr/lib/${P}/ArmPkg/Library/GccLto/*.a
"
# GenBiosId is built upstream
# VfrCompile does not use LDFLAGS but next upsteam version should change this
QA_FLAGS_IGNORED="
	usr/lib/${P}/BaseTools/Source/C/bin/VfrCompile
	usr/lib/${P}/Vlv2TbltDevicePkg/GenBiosId
"

# 1. Module name.
# 2. Target path.
add_module() {
	if use ${1}; then
		cp -r "${WORKDIR}/"*"${1}"-*/* "${S}/${2}" \
			|| die "Failed to prepare external module ${1}"
	fi
}

pkg_setup() {
	if use x86; then
		EFIARCH=IA32
	elif use amd64; then
		EFIARCH=X64
	fi

	# Select toolchain within predefined ones
	if tc-is-gcc; then
		TOOLCHAIN_TAG="GCC5"
	elif tc-is-clang; then
		TOOLCHAIN_TAG="CLANG38"
	else
		TOOLCHAIN_TAG="ELFGCC"
	fi
}

src_unpack() {
	default
	add_module brotli BaseTools/Source/C/BrotliCompress/brotli
}

src_configure() {
	sed -e '/^.*\\\s*$/{:cont;N;/^.*\\\s*$/b cont}' \
		-e "s|^\(BUILD_CFLAGS\s*=\).*$|\1 ${CFLAGS} -MD -fshort-wchar -fno-strict-aliasing -nostdlib -c -fPIC|" \
		-e "s|^\(BUILD_LFLAGS\s*=\).*$|\1 ${LDFLAGS}|" \
		-e "s|^\(BUILD_CXXFLAGS\s*=\).*$|\1 ${CXXFLAGS} -Wno-unused-result|" \
		-i "BaseTools/Source/C/Makefiles/header.makefile" \
		|| die "Failed to update makefile header"
}

src_compile() {
	local make_flags=(
		BUILD_CC="$(tc-getBUILD_CC)"
		BUILD_CXX="$(tc-getBUILD_CXX)"
		BUILD_AS="$(tc-getBUILD_AS)"
		BUILD_AR="$(tc-getBUILD_AR)"
		BUILD_LD="$(tc-getBUILD_LD)"
	)
	# Base tools does not like parallel make
	emake "${make_flags[@]}" -C BaseTools

	# Update template parameter files
	sed -e '/^.*\\\s*$/{:cont;N;/^.*\\\s*$/b cont}' \
		-e "s|^\(ACTIVE_PLATFORM\s*=\).*$|\1 MdeModulePkg/MdeModulePkg.dsc|" \
		-e "s|^\(TARGET\s*=\).*$|\1 RELEASE|" \
		-e "s|^\(TARGET_ARCH\s*=\).*$|\1 ${EFIARCH}|" \
		-e "s|^\(TOOL_CHAIN_TAG\s*=\).*$|\1 ${TOOLCHAIN_TAG}|" \
		-e "s|^\(MAX_CONCURRENT_THREAD_NUMBER\s*=\).*$|\1 $(makeopts_jobs)|" \
		-i "BaseTools/Conf/target.template" || die "Failed to configure target file"

	# Clean unneeded files
	find . -name '*.bat' -o -name '*.exe' -exec rm -f {} \; || die
	find ./BaseTools/Source/C -mindepth 1 -maxdepth 1 \! -name 'bin' -exec rm -rf {} \; || die

	# Upsteam hack (symbolic link) should only be created if needed
	rm "${S}/EmulatorPkg/Unix/Host/X11IncludeHack" || die

	# Add modules
	add_module brotli MdeModulePkg/Library/BrotliCustomDecompressLib/brotli
	add_module cmocka UnitTestFrameworkPkg/Library/CmockaLib/cmocka
	add_module oniguruma MdeModulePkg/Universal/RegularExpressionDxe/oniguruma
	add_module openssl CryptoPkg/Library/OpensslLib/openssl
	add_module softfloat ArmPkg/Library/ArmSoftFloatLib/berkeley-softfloat-3

	# Create workspace script file
	sed -e "s|{EDK_BASE}|${EPREFIX}/usr/lib/${P}|" \
		"${FILESDIR}"/edk2-workspace.template \
		> "${T}/edk2-workspace" || die "Failed to build edk2-workspace"
}

src_install() {
	dobin "${T}/edk2-workspace"

	# Use mkdir && cp here as doins does not preserve execution bits
	mkdir -p "${ED}/usr/lib/${P}" || die
	cp -pR "${S}"/* "${D}/usr/lib/${P}" || die
	dosym "${P}" "/usr/lib/${PN}"
}

pkg_postinst() {
	elog "To create a new workspace, execute:"
	elog "    . edk2-workspace [workspace_dir]"
	elog "You can link appropriate packages to your workspace. For example,"
	elog "in order to build MdeModulePkg and examples, you can try:"
	elog "    ln -s \"${EROOT}/usr/lib/${P}/\"Mde{Module,}Pkg ."
	elog "    build -a ${EFIARCH} all"
}
