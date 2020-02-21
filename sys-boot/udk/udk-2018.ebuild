# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit flag-o-matic multiprocessing python-single-r1 toolchain-funcs

DESCRIPTION="Tianocore UEFI Development kit"
HOMEPAGE="https://github.com/tianocore/tianocore.github.io/wiki/EDK-II"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tianocore/edk2.git"
	KEYWORDS=""
else
	MY_V="${PN^^}${PV}"
	SRC_URI="https://github.com/tianocore/edk2/archive/v${MY_V}.tar.gz -> ${P}.tar.gz
		doc? ( https://github.com/tianocore/edk2/releases/download/v${MY_V}/${MY_V}.Documents.zip -> ${P}-docs.zip )"
	S="${WORKDIR}/edk2-v${MY_V}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE="doc examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="strip"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	>=dev-lang/nasm-2.14.02
	>=sys-power/iasl-20160729
	doc? ( app-arch/unzip )"

DOCDIR="${WORKDIR}/Documents"

# Generated libs for EFI can contain WX sections
QA_EXECSTACK="
	usr/lib*/libBaseLib.a:*
	usr/lib*/libBaseIoLibIntrinsic.a:*
"

pkg_setup() {
	if [[ ${ARCH} == "amd64" ]]; then
		ARCH=X64
	elif [[ ${ARCH} == "x86" ]]; then
		ARCH=IA32
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

	local doc_name
	local f
	if use doc; then
		pushd "${DOCDIR}" >/dev/null || die
		rm -f *.chm || die
		for f in *.zip; do
			unpack "${DOCDIR}/${f}"
			mv html "${f%.zip}" || die
		done
		rm -f *.zip || die
		popd >/dev/null || die
	fi
}

src_configure() {
	# Compile of Base Tools is required for further setting up the environment
	# Base tools does not like parallel make
	sed -e "s:^\(BUILD_CFLAGS\s*=\).*$:\1 ${CFLAGS} -MD -fshort-wchar -fno-strict-aliasing -nostdlib -c -fPIC:" \
		-i "BaseTools/Source/C/Makefiles/header.makefile" \
		|| die "Failed to update makefile header"
	local make_flags=(
		BUILD_CC="$(tc-getBUILD_CC)"
		BUILD_CXX="$(tc-getBUILD_CXX)"
		BUILD_AS="$(tc-getBUILD_AS)"
		BUILD_AR="$(tc-getBUILD_AR)"
		BUILD_LD="$(tc-getBUILD_LD)"
	)
	emake "${make_flags[@]}" -j1 -C BaseTools
	. edksetup.sh

	# Update UDK parameter files
	sed -e "s:^\(ACTIVE_PLATFORM\s*=\).*$:\1 MdeModulePkg/MdeModulePkg.dsc:" \
		-e "s:^\(TARGET\s*=\).*$:\1 RELEASE:" \
		-e "s:^\(TARGET_ARCH\s*=\).*$:\1 ${ARCH}:" \
		-e "s:^\(TOOL_CHAIN_TAG\s*=\).*$:\1 ${TOOLCHAIN_TAG}:" \
		-e "s:^\(MAX_CONCURRENT_THREAD_NUMBER\s*=\).*$:\1 $(makeopts_jobs):" \
		-i "Conf/target.txt" || die "Failed to configure target file"
	sed -e "s:\(_\(CC\|ASM\|PP\|VFRPP\|ASLCC\|ASLPP\|DLINK\)_PATH\s*=\).*$:\1 $(tc-getCC):" \
		-e "s:\(_ASLDLINK_PATH\s*=\).*$:\1 $(tc-getLD):" \
		-e "s:\(_OBJCOPY_PATH\s*=\).*$:\1 $(tc-getOBJCOPY):" \
		-e "s:\(_RC_PATH\s*=\).*$:\1 $(tc-getOBJCOPY):" \
		-e "s:\(_SLINK_PATH\s*=\).*$:\1 $(tc-getAR):" \
		-i "Conf/tools_def.txt" \
		|| die "Failed to prepare tools definition file"
}

src_compile() {
	build $(usex examples all libraries) || die "Failed to compile environment"

# TODO * /var/tmp/portage/sys-apps/sandbox-2.10-r1/work/sandbox-2.10/libsandbox/trace.c:_do_ptrace():74: failure (Operation not permitted):
# TODO * ISE:_do_ptrace: ptrace(PTRACE_TRACEME, ..., 0x0000000000000000, 0x0000000000000000): Operation not permitted
}

src_install() {
	local f
	local build_dir="${S}/Build/MdeModule/RELEASE_${TOOLCHAIN_TAG}/${ARCH}"

	for f in "${build_dir}"/*/Library/*/*/OUTPUT/*.lib; do
		local fn="lib${f##*/}"
		newlib.a "${f}" "${fn%.lib}.a"
	done

	insinto "/usr/share/${P}"
	doins "${S}/BaseTools/Scripts/GccBase.lds"

	insinto "/usr/include/${PN}"
	doins "${S}/MdePkg/Include/"*.h
	doins -r "${S}/MdePkg/Include/"{${ARCH}/.,Guid,IndustryStandard,Library,Pi,Ppi,Protocol,Uefi}
	local hfile
	while read -d '' -r hfile; do
		doins -r "${hfile}/."
	done < <(find "${S}" -name 'BaseTools' -prune -o -name 'MdePkg' -prune -o \
		-name 'CryptoPkg' -prune -o -type d -name Include -print0)

	dobin "${S}/BaseTools/Source/C/bin/GenFw"

	local HTML_DOCS
	use doc && HTML_DOCS=( "${DOCDIR}"/. )
	einstalldocs

	local ex_rebuild_dir
	local ex_name
	local ex_build_dir
	if use examples; then
		ex_rebuild_dir="${S}/${P}-exemples"
		for f in "${S}/MdeModulePkg/Application"/*; do
			ex_name="${f##*/}"
			ebegin "Install ${ex_name} example"
			mkdir -p "${ex_rebuild_dir}/${ex_name}" || die
			ex_build_dir="${build_dir}/MdeModulePkg/Application"
			ex_build_dir="${ex_build_dir}/${ex_name}/${ex_name}"

			copySourceFiles "${f}" "${ex_rebuild_dir}/${ex_name}"
			copySourceFiles "${ex_build_dir}/DEBUG" "${ex_rebuild_dir}/${ex_name}"
			createMakefile "${ex_rebuild_dir}/${ex_name}/Makefile" \
				"${ex_name}" "${ex_build_dir}/GNUmakefile"

			tar -C "${ex_rebuild_dir}" -cf "${ex_rebuild_dir}/${ex_name}.tar" \
				"${ex_name}" || die

			eend $?
		done
		docinto "examples"
		dodoc "${ex_rebuild_dir}"/*.tar
	fi
}

##
# Parameters:
# 1 - Path where to search for source files.
# 2 - Path where source files must be copied.
copySourceFiles() {
	local dest_file
	while read -d '' -r filename; do
		dest_file="${2}${filename#${1}}"
		mkdir -p "${dest_file%/*}" || die
		mv "${filename}" "${dest_file}" || die
	done < <(find "${1}" \( -name '*.h' -o -name '*.c' \) -print0)
}

##
# Parameters:
# 1 - Path of the file to create.
# 2 - Name of the module.
# 3 - Path of the generated Makefile.
createMakefile() {
	local static_libs=$(sed -n '/^STATIC_LIBRARY_FILES\s*=/,/^\s*\$(OUTPUT_DIR)/{/^\s*\$(OUTPUT_DIR)/b;p}' ${3} \
		| sed -e 's:^\s*\$(BIN_DIR).*/\([^/]*\)\.lib:\t-l\1:' -e 's:\\$:\\\\\\n:' \
		| tr --delete '\n')
	local pecoff_header_size=$(grep -e '--defsym=PECOFF_HEADER_SIZE=' ${3} \
		| sed -e 's/^.*--defsym=PECOFF_HEADER_SIZE=\(\S*\).*$/\1/')
	local variables=$(grep -e '^IMAGE_ENTRY_POINT\s*=' -e '^CP\s*=' \
		-e '^RM\s*=' -e '^CC\s*=' -e '^DLINK\s*=' -e '^OBJCOPY\s*=' \
		-e '^GENFW\s*=' -e '^CC_FLAGS\s*=' -e '^DLINK_FLAGS\s*=' \
		-e '^OBJCOPY_FLAGS\s*=' -e '^GENFW_FLAGS\s*=' ${3} \
		| sed -e 's:$:\\n:' | tr --delete '\n')
	sed -e "s:«MODULE»:${2}:" \
		-e "s:«PACKAGE_NAME»:${PN}:" \
		-e "s:«LIB_DIR»:$(get_libdir):" \
		-e "s:«EFI_LDS»:/usr/share/${P}/GccBase.lds:" \
		-e "s:«STATIC_LIBS»:${static_libs}:" \
		-e "s:«MODULE_TYPE»:$(grep -e '^MODULE_TYPE\s*=' ${3} | tail -1):" \
		-e "s:«VARIABLES»:${variables}:" \
		-e "s:«PECOFF_HEADER_SIZE»:${pecoff_header_size}:" \
		"${FILESDIR}/${PV}-makefile.template" >${1} \
		|| die "Failed to create Makefile"
}
