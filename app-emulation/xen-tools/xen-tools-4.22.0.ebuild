# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE='ncurses,xml(+),threads(+)'

inherit flag-o-matic greadme mount-boot multilib python-single-r1 shell-completion toolchain-funcs

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	REPO="xen.git"
	EGIT_REPO_URI="https://xenbits.xen.org/git-http/${REPO}"
	S="${WORKDIR}/${REPO}"
else
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"

	EDK2_BROTLI_COMMIT="028fb5a23661f123017c060daa546b55cf4bde29"
	EDK2_COMMIT="1c74842bd07a48070d1cf3458f0b6b377e3ec8b9"
	EDK2_MIPISYST_COMMIT="370b5944c046bab043dd8b133727b2135af7747a"
	EDK2_MBEDTLS_COMMIT="8c89224991adff88d53cd380f42a2baa36f91454"
	EDK2_LIBSPDM_COMMIT="98ef964e1e9a0c39c7efb67143d3a13a819432e0"
	EDK2_OPENSSL_VERSION="3.5.1"
	QEMU_VERSION="4.20.1"
	QEMU_DTC_VERSION="1.8.1"
	QEMU_KEYCODEMAPDB_COMMIT="f5772a62ec52591ff6870b7e8ef32482371f22c6"
	QEMU_SOFTFLOAD_COMMIT="b64af41c3276f97f0e181920400ee056b9c88037"
	QEMU_TESTFLOAD_COMMIT="e7af9751d9f9fd3b47911f51a5cfd08af256a9ab"
	SEABIOS_VER="1.17.0"

	XEN_GENTOO_PATCHSET_NUM=0
	XEN_GENTOO_PATCHSET_BASE=4.22.0
	XEN_PRE_PATCHSET_NUM=
	XEN_PRE_VERSION_BASE=

	XEN_BASE_PV="${PV}"
	if [[ -n "${XEN_PRE_VERSION_BASE}" ]]; then
		XEN_BASE_PV="${XEN_PRE_VERSION_BASE}"
	fi

	SRC_URI="
	https://downloads.xenproject.org/release/xen/${XEN_BASE_PV}/xen-${XEN_BASE_PV}.tar.gz
	https://www.seabios.org/downloads/seabios-${SEABIOS_VER}.tar.gz
	https://github.com/hydrapolic/gentoo-dist/releases/download/xen-4.20.1/qemu-xen-${QEMU_VERSION}.tar.gz
	https://gitlab.com/qemu-project/dtc/-/archive/v${QEMU_DTC_VERSION}/dtc-v${QEMU_DTC_VERSION}.tar.bz2
		-> xen-qemu-dtc-${QEMU_DTC_VERSION}.tar.bz2
	https://gitlab.com/qemu-project/keycodemapdb/-/archive/${QEMU_KEYCODEMAPDB_COMMIT}/keycodemapdb-${QEMU_KEYCODEMAPDB_COMMIT}.tar.bz2
		-> xen-qemu-keycodemapdb-${QEMU_KEYCODEMAPDB_COMMIT}.tar.bz2
	https://gitlab.com/qemu-project/berkeley-softfloat-3/-/archive/${QEMU_SOFTFLOAD_COMMIT}/berkeley-softfloat-3-${QEMU_SOFTFLOAD_COMMIT}.tar.bz2
		-> xen-qemu-softload-${QEMU_SOFTFLOAD_COMMIT}.tar.bz2
	https://gitlab.com/qemu-project/berkeley-testfloat-3/-/archive/${QEMU_TESTFLOAD_COMMIT}/berkeley-testfloat-3-${QEMU_TESTFLOAD_COMMIT}.tar.bz2
		-> xen-qemu-testload-${QEMU_TESTFLOAD_COMMIT}.tar.bz2
	ovmf? (
		https://github.com/tianocore/edk2/archive/${EDK2_COMMIT}.tar.gz
			-> edk2-${EDK2_COMMIT}.tar.gz
		https://github.com/openssl/openssl/releases/download/openssl-${EDK2_OPENSSL_VERSION}/openssl-${EDK2_OPENSSL_VERSION}.tar.gz
			-> xen-ovmf-openssl-${EDK2_OPENSSL_VERSION}.tar.gz
		https://github.com/google/brotli/archive/${EDK2_BROTLI_COMMIT}.tar.gz
			-> brotli-${EDK2_BROTLI_COMMIT}.tar.gz
		https://github.com/MIPI-Alliance/public-mipi-sys-t/archive/${EDK2_MIPISYST_COMMIT}.tar.gz
			-> xen-ovmf-mipisyst-${EDK2_MIPISYST_COMMIT}.tar.gz
		https://github.com/Mbed-TLS/mbedtls/archive/${EDK2_MBEDTLS_COMMIT}.tar.gz
			-> xen-ovmf-mbedtls-${EDK2_MBEDTLS_COMMIT}.tar.gz
		https://github.com/DMTF/libspdm/archive/${EDK2_LIBSPDM_COMMIT}.tar.gz
			-> xen-ovmf-libspdm-${EDK2_LIBSPDM_COMMIT}.tar.gz
	)
	"

	if [[ -n "${XEN_PRE_PATCHSET_NUM}" ]]; then
		XEN_UPSTREAM_PATCHES_TAG="$(ver_cut 1-3)-pre-patchset-${XEN_PRE_PATCHSET_NUM}"
		XEN_UPSTREAM_PATCHES_NAME="xen-upstream-patches-${XEN_UPSTREAM_PATCHES_TAG}"
		SRC_URI+=" https://gitweb.gentoo.org/proj/xen-upstream-patches.git/snapshot/${XEN_UPSTREAM_PATCHES_NAME}.tar.bz2"
		XEN_UPSTREAM_PATCHES_DIR="${WORKDIR}/${XEN_UPSTREAM_PATCHES_NAME}"
	fi
	if [[ -n "${XEN_GENTOO_PATCHSET_NUM}" ]]; then
		XEN_GENTOO_PATCHES_TAG="$(ver_cut 1-3 ${XEN_GENTOO_PATCHSET_BASE})-gentoo-patchset-${XEN_GENTOO_PATCHSET_NUM}"
		XEN_GENTOO_PATCHES_NAME="xen-gentoo-patches-${XEN_GENTOO_PATCHES_TAG}"
		SRC_URI+=" https://gitweb.gentoo.org/proj/xen-gentoo-patches.git/snapshot/${XEN_GENTOO_PATCHES_NAME}.tar.bz2"
		XEN_GENTOO_PATCHES_DIR="${WORKDIR}/${XEN_GENTOO_PATCHES_NAME}"
	fi
fi

DESCRIPTION="Xen tools including QEMU and xl"
HOMEPAGE="https://xenproject.org"
DOCS=( README )

S="${WORKDIR}/xen-$(ver_cut 1-3 ${XEN_BASE_PV})"

LICENSE="GPL-2"
SLOT="0/$(ver_cut 1-2)"
# Inclusion of IUSE ocaml on stabalizing requires maintainer of ocaml to (get off his hands and) make
# >=dev-lang/ocaml-4 stable
# Masked in profiles/eapi-5-files instead
IUSE="debug doc flask +hvm ocaml ovmf pygrub python +qemu screen selinux sdl static-libs system-qemu system-seabios systemd"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	ovmf? ( hvm )
	pygrub? ( python )
	?? ( qemu system-qemu )"

COMMON_DEPEND="
	pygrub? ( sys-fs/e2fsprogs )
	qemu? (
		app-arch/snappy:=
		dev-libs/glib:2
		sys-libs/pam
		x11-libs/pixman
		sdl? ( media-libs/libsdl2[X] )
	)
	app-arch/bzip2
	app-arch/lz4:=
	app-arch/xz-utils
	app-arch/zstd
	dev-libs/libnl:3
	dev-libs/lzo:2
	>=dev-libs/json-c-0.15:=
	sys-apps/util-linux
	sys-libs/ncurses
	virtual/zlib:=
	${PYTHON_DEPS}
"

RDEPEND="${COMMON_DEPEND}
	sys-apps/iproute2[-minimal]
	net-misc/bridge-utils
	screen? (
		app-misc/screen
		app-admin/logrotate
	)
	selinux? ( sec-policy/selinux-xen )
	system-seabios? (
		|| (
			sys-firmware/seabios
			sys-firmware/seabios-bin
		)
	)"

DEPEND="${COMMON_DEPEND}
	app-misc/pax-utils
	>=sys-kernel/linux-headers-4.11
	$(python_gen_cond_dep '
		dev-python/lxml[${PYTHON_USEDEP}]
	')
	ovmf? (
		!arm? ( !arm64? ( dev-lang/nasm ) )
		$(python_gen_impl_dep sqlite)
		)
	!amd64? ( >=sys-apps/dtc-1.4.0 )
	amd64? ( sys-power/iasl )
	arm64? ( sys-power/iasl )
	x86? ( sys-power/iasl )
	doc? (
		app-text/ghostscript-gpl
		$(python_gen_cond_dep '
			dev-python/markdown[${PYTHON_USEDEP}]
		')
		dev-texlive/texlive-latexextra
		>=media-gfx/fig2dev-3.2.9-r1
		virtual/pandoc
	)
	hvm? ( x11-base/xorg-proto )
	qemu? (
		dev-build/meson
		$(python_gen_cond_dep '
			dev-python/distlib[${PYTHON_USEDEP}]
		')
	)
	system-qemu? ( app-emulation/qemu[xen] )
	!system-qemu? (
		dev-libs/glib:2
		x11-libs/pixman
	)
	ocaml? ( dev-ml/findlib
		dev-lang/ocaml[ocamlopt] )
	python? ( >=dev-lang/swig-4.0.0 )"

BDEPEND="dev-lang/perl
	app-alternatives/yacc
	sys-devel/gettext
	flask? ( sys-apps/checkpolicy )
	!system-seabios? ( sys-devel/gcc:* )"

# hvmloader is used to bootstrap a fully virtualized kernel
# Approved by QA team in bug #144032
QA_WX_LOAD="
	usr/libexec/xen/boot/hvmloader
	usr/libexec/xen/boot/ovmf.bin
	usr/libexec/xen/boot/xen-shim
	usr/share/qemu-xen/qemu/hppa-firmware.img
	usr/share/qemu-xen/qemu/opensbi-riscv32-generic-fw_dynamic.elf
	usr/share/qemu-xen/qemu/opensbi-riscv64-generic-fw_dynamic.elf
	usr/share/qemu-xen/qemu/s390-ccw.img
	usr/share/qemu-xen/qemu/u-boot.e500
"

QA_EXECSTACK="
	usr/share/qemu-xen/qemu/hppa-firmware.img
"

QA_PREBUILT="
	usr/libexec/xen/bin/elf2dmp
	usr/libexec/xen/bin/ivshmem-client
	usr/libexec/xen/bin/ivshmem-server
	usr/libexec/xen/bin/qemu-edid
	usr/libexec/xen/bin/qemu-img
	usr/libexec/xen/bin/qemu-io
	usr/libexec/xen/bin/qemu-keymap
	usr/libexec/xen/bin/qemu-nbd
	usr/libexec/xen/bin/qemu-pr-helper
	usr/libexec/xen/bin/qemu-storage-daemon
	usr/libexec/xen/bin/qemu-system-i386
	usr/libexec/xen/bin/virtfs-proxy-helper
	usr/libexec/xen/boot/ovmf.bin
	usr/libexec/xen/boot/xen-shim
	usr/libexec/xen/libexec/qemu-bridge-helper
	usr/libexec/xen/libexec/qemu-pr-helper
	usr/libexec/xen/libexec/virtfs-proxy-helper
	usr/libexec/xen/libexec/virtiofsd
	usr/share/qemu-xen/qemu/s390-ccw.img
	usr/share/qemu-xen/qemu/s390-netboot.img
	usr/share/qemu-xen/qemu/u-boot.e500
"

RESTRICT="test"

pkg_pretend() {
	# The XSM policy gets installed into /boot
	if use flask; then
		mount-boot_pkg_pretend
	fi
}

pkg_setup() {
	python_setup
	export "CONFIG_LOMOUNT=y"

	#bug 522642, disable compile tools/tests
	export "CONFIG_TESTS=n"

	if [[ -z ${XEN_TARGET_ARCH} ]] ; then
		if use x86 && use amd64; then
			die "Confusion! Both x86 and amd64 are set in your use flags!"
		elif use x86; then
			export XEN_TARGET_ARCH="x86_32"
		elif use amd64 ; then
			export XEN_TARGET_ARCH="x86_64"
		elif use arm; then
			export XEN_TARGET_ARCH="arm32"
		elif use arm64; then
			export XEN_TARGET_ARCH="arm64"
		else
			die "Unsupported architecture!"
		fi
	fi
}

src_prepare() {
	mv ../qemu-xen tools/qemu-xen || die

	local subprojects=tools/qemu-xen/subprojects
	mv ../dtc-v${QEMU_DTC_VERSION} ${subprojects}/dtc || die
	mv ../keycodemapdb-${QEMU_KEYCODEMAPDB_COMMIT} ${subprojects}/keycodemapdb || die
	mv ../berkeley-softfloat-3-${QEMU_SOFTFLOAD_COMMIT} ${subprojects}/berkeley-softfloat-3 || die
	mv ../berkeley-testfloat-3-${QEMU_TESTFLOAD_COMMIT} ${subprojects}/berkeley-testfloat-3 || die

	mv ${subprojects}/packagefiles/berkeley-softfloat-3/meson* ${subprojects}/berkeley-softfloat-3/ || die
	mv ${subprojects}/packagefiles/berkeley-testfloat-3/meson* ${subprojects}/berkeley-testfloat-3/ || die

	# move before Gentoo patch, one patch should apply to seabios, to fix gcc-4.5.x build err
	mv ../seabios-${SEABIOS_VER} tools/firmware/seabios-dir-remote || die
	pushd tools/firmware/ > /dev/null
	ln -s seabios-dir-remote seabios-dir || die
	popd > /dev/null

	if [[ -v XEN_UPSTREAM_PATCHES_DIR ]]; then
		eapply "${XEN_UPSTREAM_PATCHES_DIR}"
	fi

	if [[ -v XEN_GENTOO_PATCHES_DIR ]]; then
		eapply "${XEN_GENTOO_PATCHES_DIR}"
	fi

	if use ovmf; then
		local edk2=tools/firmware/ovmf-dir-remote
		mv ../edk2-${EDK2_COMMIT} ${edk2} || die
		rm -r ${edk2}/CryptoPkg/Library/OpensslLib/openssl || die
		rm -r ${edk2}/CryptoPkg/Library/MbedTlsLib/mbedtls || die
		rm -r ${edk2}/BaseTools/Source/C/BrotliCompress/brotli || die
		rm -r ${edk2}/MdeModulePkg/Library/BrotliCustomDecompressLib/brotli || die
		rm -r ${edk2}/MdePkg/Library/MipiSysTLib/mipisyst || die
		rm -r ${edk2}/SecurityPkg/DeviceSecurity/SpdmLib/libspdm || die
		mv ../openssl-${EDK2_OPENSSL_VERSION} ${edk2}/CryptoPkg/Library/OpensslLib/openssl || die
		mv ../mbedtls-${EDK2_MBEDTLS_COMMIT} ${edk2}/CryptoPkg/Library/MbedTlsLib/mbedtls || die
		mv ../public-mipi-sys-t-${EDK2_MIPISYST_COMMIT} ${edk2}/MdePkg/Library/MipiSysTLib/mipisyst || die
		mv ../libspdm-${EDK2_LIBSPDM_COMMIT} ${edk2}/SecurityPkg/DeviceSecurity/SpdmLib/libspdm || die
		cp -r ../brotli-${EDK2_BROTLI_COMMIT} ${edk2}/BaseTools/Source/C/BrotliCompress/brotli || die
		cp -r ../brotli-${EDK2_BROTLI_COMMIT} \
			${edk2}/MdeModulePkg/Library/BrotliCustomDecompressLib/brotli || die
		cp tools/firmware/ovmf-makefile ${edk2}/Makefile || die
	fi

	# Drop .config, fixes to gcc-4.6
	sed -e '/-include $(XEN_ROOT)\/.config/d' -i Config.mk || die "Couldn't	drop"

	# drop flags
	unset CFLAGS
	unset LDFLAGS
	unset ASFLAGS
	unset CPPFLAGS

	if ! use python; then
		sed -e '/^SUBDIRS-y += python$/d' -i tools/Makefile || die
	fi

	if ! use hvm; then
		sed -e '/SUBDIRS-$(CONFIG_X86) += firmware/d' -i tools/Makefile || die
	# Bug 351648
	elif ! use x86 && ! has x86 $(get_all_abis); then
		mkdir -p "${WORKDIR}"/extra-headers/gnu || die
		touch "${WORKDIR}"/extra-headers/gnu/stubs-32.h || die
		export CPATH="${WORKDIR}"/extra-headers
	fi

	if ! use qemu; then
		# Don't bother with qemu, only needed for fully virtualised guests
		sed -i '/SUBDIRS-$(CONFIG_QEMU_XEN)/s/^/#/g' tools/Makefile || die
	fi

	# Reset bash completion dir; Bug 472438
	sed -e "s;^BASH_COMPLETION_DIR      :=.*;BASH_COMPLETION_DIR := $(get_bashcompdir);" \
		-i config/Paths.mk.in || die

	# uncomment lines in xl.conf
	sed -e 's:^#autoballoon=:autoballoon=:' \
		-e 's:^#lockfile=:lockfile=:' \
		-e 's:^#vif.default.script=:vif.default.script=:' \
		-i tools/examples/xl.conf  || die

	# disable header check (Bug #921932)
	sed -e '/__XEN_INTERFACE_VERSION__/,+2d' \
		-i tools/qemu-xen/include/hw/xen/xen_native.h || die

	# Remove -Werror
	find . -type f \( -name Makefile -o -name "*.mk" \) \
		-exec sed -i \
		-e 's/-Werror //g' \
		-e '/^CFLAGS *+= -Werror$/d' \
		-e 's/, "-Werror"//' \
		{} + || die

	if use ovmf ; then
		# textrels cause failures w/ hardened binutils
		pushd tools/firmware/ovmf-dir-remote > /dev/null || die
		eapply "${FILESDIR}"/edk2-202202-binutils-2.41-textrels.patch
		popd > /dev/null || die

		# EDK2 builds BaseTools and the firmware with -Werror
		sed -i -e 's/ -Werror\b//' \
			tools/firmware/ovmf-dir-remote/BaseTools/Source/C/Makefiles/header.makefile \
			tools/firmware/ovmf-dir-remote/BaseTools/Conf/tools_def.template || die
	fi

	if ! use system-seabios ; then
		sed -i "/^export HOSTCC/i override CC:=gcc" tools/firmware/seabios-dir/Makefile || die
	fi

	default
}

src_configure() {
	local myconf=(
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--libexecdir="${EPREFIX}/usr/libexec"
		--localstatedir="${EPREFIX}/var"
		# Don't let the build host decide (bug #382573)
		--with-initddir="${EPREFIX}/etc/init.d"
		--with-sysconfig-leaf-dir=default
		--disable-golang
		--disable-pvshim
		--disable-werror
		--disable-xen
		--enable-tools
		--enable-docs
		# ROMBIOS and iPXE are only usable with the removed qemu-traditional
		--disable-ipxe
		--disable-rombios
		$(use_enable flask xsmpolicy)
		$(use_enable ocaml ocamltools)
		$(use_enable ovmf)
		$(use_enable pygrub)
		$(use_enable systemd)
		--with-xenstored=$(usex ocaml 'oxenstored' 'xenstored')
		ac_cv_path_ABI_DUMPER= # bug #791172
	)

	if use qemu; then
		local qemu_conf=(
			--disable-capstone # bug #673474
			--disable-containers # bug #732970
			--disable-gettext # bug #937219
			--disable-glusterfs
			--disable-png
			--disable-vnc-jpeg
			$(use_enable sdl)
		)
		myconf+=( --with-extra-qemuu-configure-args="${qemu_conf[*]}" )
	fi

	use system-seabios && myconf+=( --with-system-seabios="${EPREFIX}"/usr/share/seabios/bios-256k.bin )
	use system-qemu && myconf+=( --with-system-qemu=/usr/bin/qemu-system-x86_64 )
	econf "${myconf[@]}"
}

src_compile() {
	local myopt
	use debug && myopt="${myopt} debug=y"
	use python && myopt="${myopt} XENSTAT_PYTHON_BINDINGS=y"

	if test-flag-CC -fno-strict-overflow; then
		append-flags -fno-strict-overflow
	fi

	emake \
		HOSTCC="$(tc-getBUILD_CC)" \
		HOSTCXX="$(tc-getBUILD_CXX)" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		LD="$(tc-getLD)" \
		AR="$(tc-getAR)" \
		OBJDUMP="$(tc-getOBJDUMP)" \
		RANLIB="$(tc-getRANLIB)" \
		build-tools ${myopt}

	if use doc; then
		emake -C docs build
	else
		emake -C docs man-pages
	fi
}

src_install() {
	# Let the build system compile installed Python modules.
	local PYTHONDONTWRITEBYTECODE
	export PYTHONDONTWRITEBYTECODE

	emake DESTDIR="${ED}" DOCDIR="/usr/share/doc/${PF}" \
		XEN_PYTHON_NATIVE_INSTALL=y install-tools

	# Fix the remaining Python shebangs.
	python_fix_shebang "${D}"

	# Remove upstream's SysV init scripts, OpenRC ones are installed below
	rm -r "${ED}"/etc/init.d || die

	if use doc; then
		emake DESTDIR="${D}" DOCDIR="/usr/share/doc/${PF}" install-docs
		dodoc -r docs/{pdf,txt}
	else
		emake -C docs DESTDIR="${D}" DOCDIR="/usr/share/doc/${PF}" install-man-pages # Bug 668032
	fi
	dodoc ${DOCS[@]}

	newconfd "${FILESDIR}"/xendomains.confd xendomains
	newconfd "${FILESDIR}"/xenstored.confd xenstored
	newconfd "${FILESDIR}"/xenconsoled.confd xenconsoled
	newinitd "${FILESDIR}"/xendomains.initd-r2 xendomains
	newinitd "${FILESDIR}"/xenstored.initd-r1 xenstored
	newinitd "${FILESDIR}"/xenconsoled.initd xenconsoled
	newinitd "${FILESDIR}"/xencommons.initd xencommons
	newconfd "${FILESDIR}"/xencommons.confd xencommons
	newinitd "${FILESDIR}"/xenqemudev.initd xenqemudev
	newconfd "${FILESDIR}"/xenqemudev.confd xenqemudev
	newinitd "${FILESDIR}"/xen-watchdog.initd xen-watchdog

	if use screen; then
		cat "${FILESDIR}"/xendomains-screen.confd >> "${D}"/etc/conf.d/xendomains || die
		cp "${FILESDIR}"/xen-consoles.logrotate "${D}"/etc/xen/ || die
		keepdir /var/log/xen-consoles
	fi

	# For -static-libs wrt Bug 384355
	if ! use static-libs; then
		rm -f "${D}"/usr/$(get_libdir)/*.a "${D}"/usr/$(get_libdir)/ocaml/*/*.a
	fi

	# for xendomains
	keepdir /etc/xen/auto

	# Remove files failing QA AFTER emake installs them, avoiding seeking absent files
	find "${D}" \( -name openbios-sparc32 -o -name openbios-sparc64 \
		-o -name openbios-ppc -o -name palcode-clipper \) -delete || die

	keepdir /var/lib/xen/dump
	keepdir /var/lib/xen/xenpaging
	keepdir /var/lib/xenstored
	keepdir /var/log/xen

	if use python; then
		python_domodule "${S}/tools/libs/stat/bindings/swig/python/xenstat.py"
		python_domodule "${S}/tools/libs/stat/bindings/swig/python/_xenstat.so"
	fi

	python_optimize

	greadme_stdin <<-EOF
	Official Xen Guide and the official wiki page:
	- https://wiki.gentoo.org/wiki/Xen
	- https://wiki.xen.org/wiki/Main_Page

	If you use OpenRC:
	It is recommended to utilise the xencommons script to configure the
	system at boot time.
	EOF
}

pkg_preinst() {
	greadme_pkg_preinst

	if use flask; then
		mount-boot_pkg_preinst
	fi
}

pkg_prerm() {
	if use flask; then
		mount-boot_pkg_prerm
	fi
}

pkg_postinst() {
	greadme_pkg_postinst
}
