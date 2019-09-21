# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit multiprocessing python-single-r1 toolchain-funcs

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
IUSE="doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="strip"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	>=dev-lang/nasm-2.14.02
	>=sys-power/iasl-20160729
	doc? ( app-arch/unzip )"

DOCDIR="${WORKDIR}/Documents"

# EFI pre-build libs
QA_PREBUILT="
	usr/lib/${P}/BeagleBoardPkg/Debugger_scripts/rvi_dummy.axf
	usr/lib/${P}/ArmPkg/Library/GccLto/*.a
"
# GenBiosId is built upstream
# VfrCompile does not use LDFLAGS but next upsteam version should change this
QA_FLAGS_IGNORED="
	usr/lib/udk-2018/BaseTools/Source/C/bin/VfrCompile
	usr/lib/${P}/Vlv2TbltDevicePkg/GenBiosId
"

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
	sed -e "s:^\(BUILD_CFLAGS\s*=\).*$:\1 ${CFLAGS} -MD -fshort-wchar -fno-strict-aliasing -nostdlib -c -fPIC:" \
		-e "s:^\(BUILD_LFLAGS\s*=\).*$:\1 ${LDFLAGS}:" \
		-e "s:^\(BUILD_CXXFLAGS\s*=\).*$:\1 ${CXXFLAGS} -Wno-unused-result:" \
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
	emake "${make_flags[@]}" -j1 -C BaseTools

	# Update template parameter files
	sed -e "s:^\(ACTIVE_PLATFORM\s*=\).*$:\1 MdeModulePkg/MdeModulePkg.dsc:" \
		-e "s:^\(TARGET\s*=\).*$:\1 RELEASE:" \
		-e "s:^\(TARGET_ARCH\s*=\).*$:\1 ${EFIARCH}:" \
		-e "s:^\(TOOL_CHAIN_TAG\s*=\).*$:\1 ${TOOLCHAIN_TAG}:" \
		-e "s:^\(MAX_CONCURRENT_THREAD_NUMBER\s*=\).*$:\1 $(makeopts_jobs):" \
		-i "BaseTools/Conf/target.template" || die "Failed to configure target file"

	# Clean unneeded files
	find . -name '*.bat' -o -name '*.exe' -exec rm -f {} \; || die
	find ./BaseTools/Source/C -mindepth 1 -maxdepth 1 \! -name 'bin' -exec rm -rf {} \; || die

	# Upsteam hack (symbolic link) should only be created if needed
	rm "${S}/EmulatorPkg/Unix/Host/X11IncludeHack" || die

	# Create workspace script file
	sed -e "s:{EDK_BASE}:${EPREFIX}/usr/lib/${P}:" \
		"${FILESDIR}"/udk-workspace.template \
		> "${T}/udk-workspace" || die "Failed to build udk-workspace"
}

src_install() {
	dobin "${T}/udk-workspace"

	# Use mkdir && cp here as doins does not preserve execution bits
	mkdir -p "${ED}/usr/lib/${P}" || die
	cp -pR "${S}"/* "${D}/usr/lib/${P}" || die
	dosym "${P}" "/usr/lib/${PN}"

	local HTML_DOCS
	use doc && HTML_DOCS=( "${DOCDIR}"/. )
	einstalldocs
}

pkg_postinst() {
	elog "To create a new workspace, execute:"
	elog "    . udk-workspace [workspace_dir]"
	elog "You can link appropriate packages to your workspace. For example,"
	elog "in order to build MdeModulePkg and examples, you can try:"
	elog "    ln -s \"${EROOT}/usr/lib/${P}/\"Mde{Module,}Pkg ."
	elog "    build -a ${EFIARCH} all"
}
