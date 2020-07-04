# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit flag-o-matic multiprocessing python-single-r1 toolchain-funcs

MY_V="${PN^^}${PV}"

DESCRIPTION="Tianocore UEFI Development kit"
HOMEPAGE=" https://github.com/tianocore/tianocore.github.io/wiki/EDK-II"
SRC_URI="https://github.com/tianocore/${PN}/releases/download/${MY_V}/${MY_V}.Complete.MyWorkSpace.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="strip"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-lang/nasm"

S="${WORKDIR}/MyWorkSpace"

# Generated libs for EFI can contain WX sections
QA_EXECSTACK="usr/lib*/libBaseLib.a:*"

pkg_setup() {
	python_setup 'python2.7'

	if [[ ${ARCH} == "amd64" ]]; then
		ARCH=X64
	elif [[ ${ARCH} == "x86" ]]; then
		ARCH=IA32
	fi

	# We will create a custom toolchain with user defined settings
	TOOLCHAIN_TAG="CUSTOM"
}

src_unpack() {
	unpack ${A}
	unpack "${WORKDIR}/${MY_V}.MyWorkSpace.zip"

	pushd "${S}" || die
	unpack "${WORKDIR}/BaseTools(Unix).tar"

	local doc_name
	local f
	if use doc; then
		mkdir -p "${S}/doc" || die
		pushd "${S}/doc" >/dev/null || die
		for f in "${WORKDIR}/Documents/"*" Document.zip"; do
			doc_name=${f##*/}
			doc_name=${doc_name% Document.zip}
			if [[ -f "${WORKDIR}/Documents/${doc_name} Document.zip" ]]; then
				unpack "${WORKDIR}/Documents/${doc_name} Document.zip"
				mv "html" "${doc_name}" || die
			fi
		done
		popd >/dev/null || die
	fi

	popd >/dev/null || die
}

src_configure() {
	# Patch source file for permissive error (issue #639080)
	sed -e "s/\(mStringFileName == \)'\\\\0'/\1NULL/" \
		-i "${S}/BaseTools/Source/C/VfrCompile/VfrUtilityLib.cpp" \
		|| die "Failed to patch source file"
	sed -e "s/\((StringPtr != \)L'\\\\0'/\1NULL/" \
		-i "${S}/MdeModulePkg/Library/UefiHiiLib/HiiLib.c" \
		|| die "Failed to patch source file"
	# Compile of Base Tools is required for further setting up the environment
	# Base tools does not like parallel make
	sed -e "s|^\(CFLAGS\s*=\).*$|\1 ${CFLAGS} -MD -fshort-wchar -fno-strict-aliasing -nostdlib -c -fPIC|" \
		-i "${S}/BaseTools/Source/C/Makefiles/header.makefile" \
		|| die "Failed to update makefile header"
	local make_flags=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		AS="$(tc-getAS)"
		AR="$(tc-getAR)"
		LD="$(tc-getLD)"
	)
	emake "${make_flags[@]}" -j1 -C BaseTools
	. edksetup.sh BaseTools

	# Update flags in UDK parameter files
	append-cflags -fshort-wchar -fno-strict-aliasing -c
	append-cflags $(test-flags-CC -ffunction-sections)
	append-cflags $(test-flags-CC -fdata-sections)
	append-cflags $(test-flags-CC -fno-stack-protector)
	append-cflags $(test-flags-CC -fno-asynchronous-unwind-tables)
	if [[ "${ARCH}" == "X64" ]]; then
		append-cflags $(test-flags-CC -m64) $(test-flags-CC -mno-red-zone)
		append-cflags $(test-flags-CC -mcmodel=large)
	else
		append-cflags $(test-flags-CC -m32) $(test-flags-CC -malign-double)
	fi
	sed -e "s|^\(ACTIVE_PLATFORM\s*=\).*$|\1 MdeModulePkg/MdeModulePkg.dsc|" \
		-e "s|^\(TARGET\s*=\).*$|\1 RELEASE|" \
		-e "s|^\(TARGET_ARCH\s*=\).*$|\1 ${ARCH}|" \
		-e "s|^\(TOOL_CHAIN_TAG\s*=\).*$|\1 ${TOOLCHAIN_TAG}|" \
		-e "s|^\(MAX_CONCURRENT_THREAD_NUMBER\s*=\).*$|\1 $(makeopts_jobs)|" \
		-i "${S}/Conf/target.txt" || die "Failed to configure target file"
	sed -e "s|«CC»|$(tc-getCC)|" \
		-e "s|«AR»|$(tc-getAR)|" \
		-e "s|«LD»|$(tc-getLD)|" \
		-e "s|«OBJCOPY»|$(tc-getOBJCOPY)|" \
		-e "s|«CFLAGS»|${CFLAGS}|" \
		"${FILESDIR}/${PV}-tools_def.template" >>"${S}/Conf/tools_def.txt" \
		|| die "Failed to prepare tools definition file"
}

src_compile() {
	if use examples; then
		ewarn "Examples installation does not work anymore"
		ewarn "Try with a most recent version of the package"
	fi

	build libraries || die "Failed to compile environment"
}

src_install() {
	local f
	local build_dir="${S}/Build/MdeModule/RELEASE_${TOOLCHAIN_TAG}/${ARCH}"

	for f in "${build_dir}"/*/Library/*/*/OUTPUT/*.lib; do
		local fn="lib${f##*/}"
		newlib.a "${f}" "${fn%.lib}.a"
	done
	dolib.a "${S}/BaseTools/Scripts/GccBase.lds"

	insinto "/usr/include/${PN}"
	doins "${S}/MdePkg/Include/"*.h
	doins -r "${S}/MdePkg/Include/"{${ARCH}/.,Guid,IndustryStandard,Library,Pi,Ppi,Protocol,Uefi}
	local hfile
	while read -d '' -r hfile; do
		doins -r "${hfile}/."
	done < <(find "${S}" -name 'BaseTools' -prune -o -name 'MdePkg' -prune -o \
		-name 'CryptoPkg' -prune -o -type d -name Include -print0)

	dobin "${S}/BaseTools/Source/C/bin/GenFw"

	if use doc; then
		docinto "html"
		# Document installation may be very long, so split it and display message
		for f in "${S}"/doc/*; do
			ebegin "Install documentation for ${f##*/}"
			dodoc -r "${f}"
			eend $?
		done
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
	done < <(find "${1}" -name '*.h' -print0 -o -name '*.c' -print0)
}

##
# Parameters:
# 1 - Path of the file to create.
# 2 - Name of the module.
# 3 - Path of the generated Makefile.
createMakefile() {
	local static_libs=$(sed -n '/^STATIC_LIBRARY_FILES\s*=/,/^\s*\$(OUTPUT_DIR)/{/^\s*\$(OUTPUT_DIR)/b;p}' ${3} \
		| sed -e 's|^\s*\$(BIN_DIR).*/\([^/]*\)\.lib|\t-l\1|' -e 's|\\$|\\\\\\n|' | tr --delete '\n')
	local pecoff_header_size;
	[[ $ARCH == X64 ]] && pecoff_header_size='0x228' || pecoff_header_size='0x220'
	sed -e "s|«MODULE»|${2}|" \
		-e "s|«PACKAGE_NAME»|${PN}|" \
		-e "s|«STATIC_LIBS»|${static_libs}|" \
		-e "s|«MODULE_TYPE»|$(grep -e '^MODULE_TYPE\s*=' ${3} | tail -1)|" \
		-e "s|«IMAGE_ENTRY_POINT»|$(grep -e '^IMAGE_ENTRY_POINT\s*=' ${3})|" \
		-e "s|«CP»|$(grep -e '^CP\s*=' ${3})|" \
		-e "s|«RM»|$(grep -e '^RM\s*=' ${3})|" \
		-e "s|«CC»|$(grep -e '^CC\s*=' ${3})|" \
		-e "s|«DLINK»|$(grep -e '^DLINK\s*=' ${3})|" \
		-e "s|«OBJCOPY»|$(grep -e '^OBJCOPY\s*=' ${3})|" \
		-e "s|«GENFW»|$(grep -e '^GENFW\s*=' ${3})|" \
		-e "s|«PECOFF_HEADER_SIZE»|${pecoff_header_size}|" \
		-e "s|«OBJCOPY_FLAGS»|$(grep -e '^OBJCOPY_FLAGS\s*=' ${3})|" \
		-e "s|«GENFW_FLAGS»|$(grep -e '^GENFW_FLAGS\s*=' ${3})|" \
		"${FILESDIR}/${PV}-makefile.template" >${1} \
		|| die "Failed to create Makefile"
}
