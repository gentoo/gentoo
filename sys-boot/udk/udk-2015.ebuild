# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit flag-o-matic multiprocessing python-single-r1 toolchain-funcs versionator

MY_V="${PN^^}$(get_version_component_range 1)"

DESCRIPTION="Tianocore UEFI Development kit"
HOMEPAGE="http://www.tianocore.org/edk2/"
SRC_URI="https://github.com/tianocore/${PN}/releases/download/${MY_V}/${MY_V}.Complete.MyWorkSpace.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-lang/nasm"

S="${WORKDIR}/MyWorkSpace"

pkg_setup() {
	python_setup 'python2.7'

	local uname_arch=$(uname -m | sed -e 's:i[3456789]86:IA32:')
	if [[ ${uname_arch} == "x86_64" ]] || [[ ${uname_arch} == "amd64" ]] ; then
		export ARCH=X64
	else
		export ARCH=${uname_arch}
	fi

	# We will create a custom toolchain with user defined settings
	export TOOLCHAIN_TAG="CUSTOM"
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
			doc_name=$(echo ${f} | sed -e 's:^.*/\([^/]*\) Document[.]zip$:\1:')
			if [[ -f "${WORKDIR}/Documents/${doc_name} Document.zip" ]]; then
				unpack "${WORKDIR}/Documents/${doc_name} Document.zip"
				mv "${S}/doc/html" "${S}/doc/${doc_name}" || die
			fi
		done
		popd >/dev/null || die
	fi

	popd >/dev/null || die
}

src_configure() {
	# Compile of Base Tools is required for further setting up the environment
	# Base tools does not like parallel make
	local cflags_save=${CFLAGS}
	append-cflags $(test-flags-CC -MD) $(test-flags-CC -fshort-wchar)
	append-cflags $(test-flags-CC -fno-strict-aliasing)
	append-cflags $(test-flags-CC -nostdlib) $(test-flags-CC -c)
	append-cflags $(test-flags-CC -fPIC)
	sed -e "s:^\(CFLAGS\s*=\).*$:\1 ${CFLAGS}:" \
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
	CFLAGS=${cflags_save}
	append-cflags $(test-flags-CC -fshort-wchar)
	append-cflags $(test-flags-CC -fno-strict-aliasing) $(test-flags-CC -c)
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
	sed -e "s:^\(ACTIVE_PLATFORM\s*=\).*$:\1 MdeModulePkg/MdeModulePkg.dsc:" \
		-e "s:^\(TARGET\s*=\).*$:\1 RELEASE:" \
		-e "s:^\(TARGET_ARCH\s*=\).*$:\1 ${ARCH}:" \
		-e "s:^\(TOOL_CHAIN_TAG\s*=\).*$:\1 ${TOOLCHAIN_TAG}:" \
		-e "s:^\(MAX_CONCURRENT_THREAD_NUMBER\s*=\).*$:\1 $(makeopts_jobs):" \
		-i "${S}/Conf/target.txt" || die "Failed to configure target file"
	sed -e "s:«CC»:$(tc-getCC):" \
		-e "s:«AR»:$(tc-getAR):" \
		-e "s:«LD»:$(tc-getLD):" \
		-e "s:«OBJCOPY»:$(tc-getOBJCOPY):" \
		-e "s:«CFLAGS»:${CFLAGS}:" \
		"${FILESDIR}/${PV}-tools_def.template" >>"${S}/Conf/tools_def.txt" \
		|| die "Failed to prepare tools definition file"
}

src_compile() {
	local build_target
	if use examples; then
		build_target=all
	else
		build_target=libraries
	fi

	build ${build_target} || die "Failed to compile environment"
}

src_install() {
	local f
	local build_dir="${S}/Build/MdeModule/RELEASE_${TOOLCHAIN_TAG}/${ARCH}"

	for f in "${build_dir}"/*/Library/*/*/OUTPUT/*.lib; do
		newlib.a "${f}" lib$(basename "${f}" .lib).a
	done
	dolib "${S}/BaseTools/Scripts/GccBase.lds"

	local include_dest="/usr/include/${PN}"
	for f in "" /Guid /IndustryStandard /Library /Pi /Ppi /Protocol /Uefi; do
		insinto "${include_dest}${f}"
		doins "${S}/MdePkg/Include${f}"/*.h
	done
	insinto "${include_dest}"
	doins "${S}/MdePkg/Include/${ARCH}"/*.h
	local hfile
	find "${S}" -name 'BaseTools' -prune -o -name 'MdePkg' -prune -o \
		-name 'CryptoPkg' -prune -o -type d -name Include \
		-exec find {} -maxdepth 0 \; \
		| while read hfile; do
		doins -r "${hfile}"/*
	done

	dobin "${S}/BaseTools/Source/C/bin/GenFw"

	if use doc; then
		docinto "html"
		# Document installation may be very long, so split it and display message
		for f in "${S}"/doc/*; do
			ebegin "Installing documentation for $(basename ${f}), please wait"
			dodoc -r "${f}"
			eend $?
		done
	fi

	local ex_rebuild_dir
	local ex_name
	local ex_build_dir
	if use examples; then
		ex_rebuild_dir="${S}/${P}-exemples"
		for f in "${S}/MdeModulePkg/Application"/*; do
			ex_name=$(basename "${f}")
			ebegin "Preparing ${ex_name} example"
			mkdir -p "${ex_rebuild_dir}/${ex_name}" || die
			ex_build_dir="${build_dir}/MdeModulePkg/Application"
			ex_build_dir="${ex_build_dir}/${ex_name}/${ex_name}"

			copySourceFiles "${f}" "${ex_rebuild_dir}/${ex_name}"
			copySourceFiles "${ex_build_dir}/DEBUG" "${ex_rebuild_dir}/${ex_name}"
			createMakefile "${ex_rebuild_dir}/${ex_name}/Makefile" \
				"${ex_name}" "${ex_build_dir}/GNUmakefile"

			tar -C "${ex_rebuild_dir}" -cf "${ex_rebuild_dir}/${ex_name}.tar" \
				"${ex_name}" || die

			eend $? "Failed to create example file"
		done
		docinto "examples"
		dodoc "${ex_rebuild_dir}"/*.tar
	fi

# TODO * QA Notice: The following files contain writable and executable sections
# TODO * !WX --- --- usr/lib64/libBaseLib.a:Thunk16.obj
# TODO * !WX --- --- usr/lib64/libBaseLib.a:SwitchStack.obj
# TODO * !WX --- --- usr/lib64/libBaseLib.a:SetJump.obj
# TODO * !WX --- --- usr/lib64/libBaseLib.a:LongJump.obj
# TODO * !WX --- --- usr/lib64/libBaseLib.a:EnableDisableInterrupts.obj
# TODO * !WX --- --- usr/lib64/libBaseLib.a:DisablePaging64.obj
# TODO * !WX --- --- usr/lib64/libBaseLib.a:CpuId.obj
# TODO * !WX --- --- usr/lib64/libBaseLib.a:CpuIdEx.obj
# TODO * !WX --- --- usr/lib64/libBaseLib.a:EnableCache.obj
# TODO * !WX --- --- usr/lib64/libBaseLib.a:DisableCache.obj
# TODO * QA Notice: Package triggers severe warnings which indicate that it
# TODO *            may exhibit random runtime failures.
# TODO * /usr/include/bits/string3.h:90:70: warning: call to void* __builtin___memset_chk(void*, int, long unsigned int, long unsigned int) will always overflow destination buffer
}

##
# Parameters :
# 1 - Path where to search for source files.
# 2 - Path where source files must be copied.
copySourceFiles() {
	local dest_file
	while read -d '' -r filename; do
		dest_file="${2}${filename#${1}}"
		mkdir -p $(dirname "${dest_file}") || die
		mv "${filename}" "${dest_file}" || die
	done < <(find "${1}" -name '*.h' -print0 -o -name '*.c' -print0)
}

##
# Parameters :
# 1 - Path of the file to create.
# 2 - Name of the module.
# 3 - Path of the generated Makefile.
createMakefile() {
	local static_libs=$(sed -n '/^STATIC_LIBRARY_FILES\s*=/,/^\s*\$(OUTPUT_DIR)/{/^\s*\$(OUTPUT_DIR)/b;p}' ${3} \
		| sed -e 's:^\s*\$(BIN_DIR).*/\([^/]*\)\.lib:\t-l\1:' -e 's:\\$:\\\\\\n:' | tr --delete '\n')
	local pecoff_header_size;
	[[ $ARCH == X64 ]] && pecoff_header_size='0x228' || pecoff_header_size='0x220'
	sed -e "s:«MODULE»:${2}:" \
		-e "s:«PACKAGE_NAME»:${PN}:" \
		-e "s:«STATIC_LIBS»:${static_libs}:" \
		-e "s:«MODULE_TYPE»:$(grep -e '^MODULE_TYPE\s*=' ${3} | tail -1):" \
		-e "s:«IMAGE_ENTRY_POINT»:$(grep -e '^IMAGE_ENTRY_POINT\s*=' ${3}):" \
		-e "s:«CP»:$(grep -e '^CP\s*=' ${3}):" \
		-e "s:«RM»:$(grep -e '^RM\s*=' ${3}):" \
		-e "s:«CC»:$(grep -e '^CC\s*=' ${3}):" \
		-e "s:«DLINK»:$(grep -e '^DLINK\s*=' ${3}):" \
		-e "s:«OBJCOPY»:$(grep -e '^OBJCOPY\s*=' ${3}):" \
		-e "s:«GENFW»:$(grep -e '^GENFW\s*=' ${3}):" \
		-e "s:«PECOFF_HEADER_SIZE»:${pecoff_header_size}:" \
		-e "s:«OBJCOPY_FLAGS»:$(grep -e '^OBJCOPY_FLAGS\s*=' ${3}):" \
		-e "s:«GENFW_FLAGS»:$(grep -e '^GENFW_FLAGS\s*=' ${3}):" \
		"${FILESDIR}/${PV}-makefile.template" >${1} \
		|| die "Failed to create Makefile"
}
